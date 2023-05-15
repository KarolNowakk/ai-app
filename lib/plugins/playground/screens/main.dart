import 'dart:developer';
import 'package:app2/shared/elements/default_scaffold.dart';
import 'package:app2/shared/elements/text_field.dart';
import 'package:app2/plugins/lang/domain/exercise_structure.dart' as exe;
import 'package:app2/plugins/playground/domain/ai_service.dart';
import 'package:app2/plugins/playground/domain/conversation.dart';
import 'package:app2/plugins/playground/screens/drawer.dart';
import 'package:app2/plugins/playground/screens/stream_message.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:app2/shared/elements/infinity_button.dart';
import 'package:kiwi/kiwi.dart';

class PlaygroundScreen extends StatefulWidget {
  final AIServiceInterface _service = KiwiContainer().resolve<AIServiceInterface>();

  static const String route = "/playground";
  final AIConversation? defaultConv;

  PlaygroundScreen({super.key, this.defaultConv});

  @override
  _PlaygroundScreenState createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  final TextEditingController _systemTextController = TextEditingController();
  final List<StreamMessage> _messages = [];
  final OptionsDrawer drawer = OptionsDrawer();

  @override
  void initState() {
    super.initState();
    if (widget.defaultConv != null) {
      _setDefaults(widget.defaultConv!);
    }
  }

  void _addMessage() {
    int index = _messages.length;
    StreamMessage msg = StreamMessage.text(text: "", role: StreamMessage.roleUser, index: index, delete: _deleteMessage);

    setState(() {
      _messages.add(msg);
    });
  }

  void _deleteMessage(int index) {
    setState(() {
      _messages.removeAt(index);
    });

    // update indexes
    for (int i = 0; i < _messages.length; i++) {
      _messages[i].index = i;
    }
  }

  AIConversation _getCurrentConv() {
    List<Message> msgs = [];
    msgs.add(Message(role: "system", content: _systemTextController.text));

    _messages.forEach((element) {
      element.getData((String content, role) {
        msgs.add(Message(role: role, content: content));
      });
    });

    AIConversation conv = AIConversation();

    drawer.getData((title, model, topP, temp) {
      conv = AIConversation(
        title: title,
        model: model,
        topP: topP,
        temperature: temp,
        completionChoices: 1,
        messages: msgs,
        maxTokens: 8192,
      );
    });

    log(conv.toString());

    return conv;
  }

  void _submit() {
    AIConversation conv = _getCurrentConv();
    Stream<String> streamMsg = widget._service.kindlyAskAI(conv);

    StreamMessage msg = StreamMessage.stream(
        textStream: streamMsg,
        role: StreamMessage.roleAssistant,
        index: _messages.length,
        delete: _deleteMessage,
    );

    setState(() {
      _messages.add(msg);
    });
  }

  void _setDefaults(AIConversation conv) {
    setState(() {
      drawer.setData(conv.title ?? "", conv.model, conv.topP ?? 0.5, conv.temperature ?? 0.5);

      for (int i = 0; i < conv.messages!.length; i++) {
        if (conv.messages![i].role == "system") {
          _systemTextController.text = conv.messages![i].content;
          return;
        }

        StreamMessage msg = StreamMessage.text(text: "", role: conv.messages![i].role, index: i, delete: _deleteMessage);
        _messages.add(msg);
      }
    });
  }

  void _resetConversation() {
    setState(() {
      _messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ),
      ],
      drawer: drawer,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            DefaultTextWidget(controller: _systemTextController, hint: "System message..."),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    color: DarkTheme.backgroundDarker,
                    width: 1.5,
                  ),
                ),
                child: ListView.builder(
                  cacheExtent: 100,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _messages[index];
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: InfinityButton(
                    onPressed: _addMessage,
                    text: "Add Message",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InfinityButton(
                    onPressed: _resetConversation,
                    text: "Reset",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InfinityButton(
                    onPressed: () {},
                    text: "Export",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            InfinityButton(
              color: DarkTheme.secondary,
              onPressed: _submit,
              text: "Submit",
            ),
          ],
        ),
      ),
    );
  }
}
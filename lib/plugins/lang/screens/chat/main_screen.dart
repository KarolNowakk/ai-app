import 'package:app2/plugins/lang/application/srs_alg.dart';
import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/lang/interfaces/word_excercises_controller.dart';
import 'package:app2/shared/conversation/domain/conversation.dart';
import 'package:app2/shared/chat_message/domain/chat_message.dart';
import 'package:app2/shared/chat_message/elements/audio_ai_message.dart';
import 'package:app2/shared/elements/default_scaffold.dart';
import 'package:app2/shared/helpers/helpers.dart';
import 'package:app2/shared/history/domain/conv_history.dart';
import 'package:app2/shared/history/elements/history_drawer.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'chat_input.dart';
import 'chat_messages.dart';

class ExercisesChatScreen extends StatefulWidget {
  final WordExercisesController _controller =
      KiwiContainer().resolve<WordExercisesController>();
  final RateWordModalInterface _wordModal =
      KiwiContainer().resolve<RateWordModalInterface>();
  final SaveWordModalInterface _saveWordModalController =
      KiwiContainer().resolve<SaveWordModalInterface>();

  List<Widget> messages = [];

  List<WordData> _wordRecentlyUsed = [];

  @override
  _ExercisesChatScreenState createState() => _ExercisesChatScreenState();
}

class _ExercisesChatScreenState extends State<ExercisesChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _chatFieldFocus = FocusNode();
  late ScrollController _scrollController;
  late int _remainingWords;
  String? _exerciseId;
  String convId = "";

  void _saveConv(List<ChatCompletionMessage> messages) {
    if (convId == "") {
      convId = generateRandomString(19);
      widget._controller.createConvHistory(convId, messages);
      return;
    }

    widget._controller.updateConvHistory(convId, messages);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _remainingWords = widget._controller.remainingWords();

    widget._controller.getId().then((value) {
      _exerciseId = value;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void getNextSentence() async {
    await evaluateWords();

    addDivider();
    List<ChatCompletionMessage> messages = extractMessages();

    widget._controller.requestExercises(messages).then((data) {
      addTextMessage(context, data.exeRequest, false);

      addStreamMessage(context, data.sentence, true);
      widget._wordRecentlyUsed = data.data;

      setState(() {
        _remainingWords = widget._controller.remainingWords();
      });

      data.sentence.listen(
        null,
        onDone: () {
          convId = "";
          messages = extractMessages();
          _saveConv(messages);
        });
    });
  }

  Future<void> evaluateWords() async {
    List<WordData> wordsCopy = List<WordData>.from(widget._wordRecentlyUsed);

    for (int i = 0; i < wordsCopy.length; i++) {
      await widget._wordModal.show(context, wordsCopy[i]);
      widget._wordRecentlyUsed.remove(wordsCopy[i]);
    }
  }

  void sendAMessage(String msg) {
    addTextMessage(context, msg, false);

    List<ChatCompletionMessage> messages = extractMessages();

    widget._controller.sendAMessage(messages).then((stream) {
      addStreamMessage(context, stream, true);

      stream.listen(
        null,
        onDone: () {
          messages = extractMessages();
          _saveConv(messages);
      });
    });
  }

  void addTextMessage(BuildContext context, String msg, bool isAIMessage) {
    setState(() {
      widget.messages.add(Message.text(
          text: msg, isAIMsg: isAIMessage, scrollToBottom: scrollToBottom));
    });
    scrollToBottom();
  }

  void addStreamMessage(
      BuildContext context, Stream<String> msgStream, bool isAIMessage) {
    setState(() {
      widget.messages.add(AudioAIMessage(
          textStream: msgStream, scrollToBottom: scrollToBottom));
    });
    scrollToBottom();
  }

  void addDivider() {
    setState(() {
      widget.messages.add(Divider());
    });
    scrollToBottom();
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 10), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
    });
  }

  // extreects messages from current conversation, if it steps upon Divider then it stops collecting
  List<ChatCompletionMessage> extractMessages() {
    List<ChatCompletionMessage> messageList = [];

    for (var i = widget.messages.length - 1; i >= 0; i--) {
      if (widget.messages[i] is ChatMessageInterface) {
        ChatMessageInterface msg = widget.messages[i] as ChatMessageInterface;
        messageList.insert(0, ChatCompletionMessage(
          role: msg.getRole(),
          content: msg.getContent(),
        ));

        continue;
      }

      break;
    }

    return messageList;
  }

  void loadFromHistory(ConvHistory hist) {
    if (hist.additionalData != null && hist.additionalData!.containsKey(ConvHistory.wordsListEntry)) {
      widget._wordRecentlyUsed.clear();

      List<String> wordsList = (hist.additionalData![ConvHistory.wordsListEntry] as List<dynamic>)
          .map((item) => item as String)
          .toList();

      widget._controller.getUsedWords(wordsList).then((value) {
        widget._wordRecentlyUsed.addAll(value);
      });
    }

    widget.messages.clear();

    addDivider(); // just for consistent look

    for (var message in hist.msgs!) {
      switch (message.role) {
        case ChatCompletionMessage.roleSystem:
          break;
        case ChatCompletionMessage.roleUser:
          addTextMessage(context, message.content, false);
          break;
        case ChatCompletionMessage.roleAssistant:
          setState(() {
            widget.messages.add(AudioAIMessage.withoutStream(
                displayText: message.content, scrollToBottom: scrollToBottom));
          });
          scrollToBottom();
          break;
        default:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      drawer: _exerciseId != null ?
      HistoryDrawer(
        parentId: _exerciseId!,
      ) :
      null,
      actions: [
        // _remainingWords != 0
            Text(style: TextStyle(color: DarkTheme.textColor),'$_remainingWords'),
            // : const SizedBox.shrink(),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            widget._saveWordModalController.showSaveWordModal(context, "");
          },
        ),
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              setState(() {
                print("nic");
              });
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ),
      ],
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: GestureDetector(
                  onTap: _chatFieldFocus.unfocus,
                  child: ListView.builder(
                    cacheExtent: 100,
                    itemCount: widget.messages.length,
                    itemBuilder: (context, index) {
                      return widget.messages[index];
                    },
                    controller: _scrollController,
                  ),
                ),
              ),
            ),
            ChatInput(
              focus: _chatFieldFocus,
              onHoldAction: evaluateWords,
              controller: _textEditingController,
              getNextPrompt: getNextSentence,
              sendAMessage: sendAMessage,
            ),
          ],
        ),
      ),
    );
  }
}

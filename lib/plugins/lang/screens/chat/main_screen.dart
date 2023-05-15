import 'package:app2/plugins/lang/application/srs_alg.dart';
import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/lang/interfaces/word_excercises_controller.dart';
import 'package:app2/shared/elements/audio_ai_message.dart';
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

  WordData? _wordRecentlyUsed;

  @override
  _ExercisesChatScreenState createState() => _ExercisesChatScreenState();
}

class _ExercisesChatScreenState extends State<ExercisesChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _chatFieldFocus = FocusNode();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void getNextSentence() {
    widget._controller.resetConversation();

    WordData? recentlyUsed = widget._wordRecentlyUsed;
    if (recentlyUsed != null) {
      widget._wordModal.show(context, recentlyUsed);
    }

    widget._controller.requestExercises().then((data) {
      addStreamMessage(context, data.sentence, true);

      widget._wordRecentlyUsed = data.data;
    });
  }

  void sendAMessage(String msg) {
    addTextMessage(context, msg, false);
    Stream<String> result = widget._controller.sendAMessage(context, msg);
    addStreamMessage(context, result, true);
  }

  void addTextMessage(BuildContext context, String msg, bool isAIMessage) {
    setState(() {
      widget.messages.add(Message.text(text: msg, isAIMsg: isAIMessage, scrollToBottom: scrollToBottom));
    });
    scrollToBottom();
  }

  void addStreamMessage(BuildContext context, Stream<String> msgStream, bool isAIMessage) {
      setState(() {
        widget.messages.add(AudioAIMessage(textStream: msgStream, scrollToBottom: scrollToBottom));
      });
      scrollToBottom();
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 10), () {
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0.0,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget._controller.resetConversation();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              widget._saveWordModalController.showSaveWordModal(context, "");
            },
          ),
        ],
      ),
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


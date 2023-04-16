import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/lang/interfaces/word_excercises_controller.dart';
import 'package:app2/plugins/lang/screens/style/color.dart';
import 'package:dart_openai/openai.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'chat_input.dart';
import 'chat_messages.dart';

class ExercisesChatScreen extends StatefulWidget {
  @override
  _ExercisesChatScreenState createState() => _ExercisesChatScreenState();
}

class _ExercisesChatScreenState extends State<ExercisesChatScreen> {
  final WordExercisesController _controller = KiwiContainer().resolve<WordExercisesController>();
  final RateWordModalInterface _wordModal = KiwiContainer().resolve<RateWordModalInterface>();
  final SaveWordModalInterface _saveWordModalController = KiwiContainer().resolve<SaveWordModalInterface>();

  List<Message> messages = [];
  WordData? _wordRecentlyUsed;
  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();

  void getNextSentence() {
    _controller.resetConversation();

    WordData? recentlyUsed = _wordRecentlyUsed;
    if (recentlyUsed != null) {
      _wordModal.show(context, recentlyUsed);
    }

    _controller.requestExercises().then((data) {
      addStreamMessage(context, data.sentence, true);

      _wordRecentlyUsed = data.data;
    });
  }

  void sendAMessage(String msg) {
    addTextMessage(context, msg, false);

    Stream<String> result = _controller.sendAMessage(context, msg);

    addStreamMessage(context, result, true);
  }

  void addTextMessage(BuildContext context, String msg, bool isAIMessage) {
    setState(() {
      messages.add(Message.text(text: msg, isUserMessage: isAIMessage));
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
      });
    });
  }

  void addStreamMessage(BuildContext context, Stream<String> msg, bool isAIMessage) {
    setState(() {
      messages.add(Message.stream(textStream: msg, isUserMessage: isAIMessage));
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _controller.resetConversation();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _saveWordModalController.showSaveWordModal(context, "");
            },
          ),
        ],
      ),
      body: Container(
        color: backgroundColor,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return messages[index];
                },
                controller: scrollController, // Add the ScrollController here
              ),
            ),
            ChatInput(
              controller: textEditingController,
              getNextPrompt: getNextSentence,
              sendAMessage: sendAMessage,
            ),
          ],
        ),
      ),
    );
  }
}
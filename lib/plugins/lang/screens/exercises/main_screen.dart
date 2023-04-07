import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:app2/plugins/lang/interfaces/word_excercises_controller.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'chat_input.dart';
import 'chat_messages.dart';

class ExercisesChatScreen extends StatefulWidget {
  @override
  _ExercisesChatScreenState createState() => _ExercisesChatScreenState();
}

class _ExercisesChatScreenState extends State<ExercisesChatScreen> {
  List<Message> messages = [];
  bool _wasPromptJustSend = false;
  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final WordExercisesController _controller = KiwiContainer().resolve<
      WordExercisesController>();
  final RateWordModalInterface _wordModal = KiwiContainer().resolve<
      RateWordModalInterface>();

  void getNextSentence() {
    if (_wasPromptJustSend) {
      addMessage(context, "First answer recently requested prompt", true);
      return;
    }

    _controller.requestExercises().then((sentence) {
      addMessage(context, sentence, true);
      _wasPromptJustSend = true;
    });
  }

  void sendAMessage(String msg) {
    addMessage(context, msg, false);
    _controller.sendAMessage(context, msg).then((result) {
      addMessage(context, result.sentence, true);

      WordData? data = result.data;

      print(result);
      if (_wasPromptJustSend && data != null) {
        _wordModal.show(context, data);
      }

      _wasPromptJustSend = false;
    });
  }

  void addMessage(BuildContext context, String msg, bool isAIMessage) {
    setState(() {
      messages.add(Message(text: msg, isUserMessage: isAIMessage));
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
        backgroundColor: Colors.amber,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _controller.resetConversation();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: Colors.black,
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
import 'package:app2/plugins/lang/interfaces/word_excercises_controller.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'chat_input.dart';
import 'chat_messages.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> messages = [];
  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final WordExercisesController _controller = KiwiContainer().resolve<WordExercisesController>();

  void getNextSentence() {
    _controller.requestExercises().then((sentence) {
        setState(() {
          messages.add(Message(text: sentence, isUserMessage: true));
          Future.delayed(Duration(milliseconds: 100), () {
            scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut);
          });
        });
    });
  }

  void sendAMessage(String msg) {
    setState(() {
      messages.add(Message(text: msg, isUserMessage: false));
      Future.delayed(Duration(milliseconds: 100), () {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    });

    _controller.sendAMessage(context, msg).then((sentence) {
      setState(() {
        messages.add(Message(text: sentence, isUserMessage: true));
        Future.delayed(Duration(milliseconds: 100), () {
          scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
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
    );
  }
}
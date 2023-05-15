import 'dart:developer';
import 'package:app2/plugins/lang/domain/word_structure.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

// List<Message> messagesForAI = [
//   Message(role: systemRole, content: '''
//   You are a professional translator of all languages. Follow those rules:
//     - Give a few possible translation.
//     - Keep the answers as short as possible.
// '''),
// ];

class StreamDetails extends StatefulWidget {
  // final AICommunicatorInterface _ai = KiwiContainer().resolve<AICommunicatorInterface>();
  final WordData data;

  StreamDetails({required this.data});

  @override
  _StreamDetailsState createState() => _StreamDetailsState();
}

class _StreamDetailsState extends State<StreamDetails> {
  String _detailsFromGPT = '';

  void _addText() {
    // _detailsFromGPT = "";
    // String text = 'Please translate this word ${widget.data.lang} ${widget.data.word} to polish';
    // widget._ai.setMessageList(messagesForAI);
    // Stream<String> stream = widget._ai.kindlyAskAI(text);
    //
    // _listenToStream(stream);
  }

  void _listenToStream(Stream<String> stream) {
    stream.listen((data) {
      setState(() {
        _detailsFromGPT += data;
      });
    }, onDone: () {
    }, onError: (error) {
      log('Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: _addText,
            child: const Text('Ask GPT for more details'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.all(5.0),
              // height: 100,
              // color: Theme.of(context).colorScheme.onBackground,
              child: Container(
                padding: EdgeInsets.zero,
                child: SelectableText(
                  _detailsFromGPT,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'dart:io';
import 'package:app2/plugins/lang/screens/style/color.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

abstract class SaveWordModalInterface {
  void showSaveWordModal(BuildContext context, String text);

  void hideSaveWorldModal(BuildContext context);
}

class Message extends StatefulWidget {
  final String? text;
  final Stream<String>? textStream;
  final bool isUserMessage;

  Message.text({Key? key, required this.text, required this.isUserMessage})
      : textStream = null,
        super(key: key);

  Message.stream(
      {Key? key, required this.textStream, required this.isUserMessage})
      : text = null,
        super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final SaveWordModalInterface _saveWordModalController =
      KiwiContainer().resolve<SaveWordModalInterface>();
  String _text = "";

  @override
  void initState() {
    super.initState();
    if (widget.text != null) {
      _text = widget.text!;
    }
    if (widget.textStream != null) {
      widget.textStream!.listen((data) {
        setState(() {
          _text += data;
        });
      }, onError: (error) {
        print('Error: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildMessage(_text, context);
  }

  Widget _buildMessage(String content, BuildContext context) {
    return Container(
      alignment:
          widget.isUserMessage ? Alignment.centerLeft : Alignment.centerRight,
      margin: widget.isUserMessage
          ? const EdgeInsets.only(left: 10, top: 10, right: 50, bottom: 10)
          : const EdgeInsets.only(left: 50, top: 10, right: 10, bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: widget.isUserMessage ? Colors.grey.withAlpha(200) : accentColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9 * 0.95),
        child: SelectableText(
          content,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.normal,
            fontSize: 16,
            decoration: TextDecoration.none,
          ),

          // just comment it out for now 
          // onSelectionChanged: (a, b) {
          //   String selectedText = a.textInside(content);
          //   sleep(const Duration(seconds: 1));
          //   _saveWordModalController.showSaveWordModal(context, selectedText);
          // },
        ),
      ),
    );
  }
}

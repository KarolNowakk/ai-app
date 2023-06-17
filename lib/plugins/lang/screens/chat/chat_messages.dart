import 'package:app2/shared/conversation/domain/conversation.dart';
import 'package:app2/shared/chat_message/domain/chat_message.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class Message extends StatefulWidget implements ChatMessageInterface{
  final String? text;
  String displayText = "";
  final Stream<String>? textStream;
  final bool isAIMsg;
  final Function()scrollToBottom;
  bool isStreamDone = false;

  Message.text({Key? key, required this.text, required this.isAIMsg, required this.scrollToBottom})
      : textStream = null,
        super(key: key);

  Message.stream(
      {Key? key, required this.textStream, required this.isAIMsg, required this.scrollToBottom})
      : text = null,
        super(key: key);

  @override
  String getRole() {
    return this.isAIMsg ? ChatCompletionMessage.roleAssistant : ChatCompletionMessage.roleUser;
  }

  @override
  String getContent() {
    return text ?? displayText;
  }

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  late Color color;
  late EdgeInsets margin;
  late Alignment alingment;

  @override
  void initState() {
    super.initState();
    color = widget.isAIMsg
        ? DarkTheme.primary
        : DarkTheme.secondary;
    margin = widget.isAIMsg
        ? const EdgeInsets.only(left: 10, top: 8, right: 70, bottom: 0)
        : const EdgeInsets.only(left: 70, top: 8, right: 10, bottom: 0);
    alingment = widget.isAIMsg ? Alignment.centerLeft : Alignment.centerRight;

    if (widget.text != null) {
      widget.displayText = widget.text!;
      return;
    }

    if (widget.isStreamDone && widget.displayText != "") {
        return;
    }

    try {
      // very interesting, when there is exception in init state
      // and you use it in list view builder, console will not tell you,
      // and you might spend 4h on trying to figure out what is wrong with your code
      _listenToStream();
    } catch (e) {
      widget.displayText = "There was an error on stream: ${e.toString()}" ;
      color = Colors.redAccent;
    }
  }

  void _listenToStream() {
    if (widget.textStream != null) {
      widget.textStream!.listen((data) {
        setState(() {
          widget.displayText += data;
          widget.scrollToBottom();
        });
      }, onDone: () {
        widget.isStreamDone = true;
      }, onError: (error) {
        log('Error: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildMessage(widget.displayText, context);
  }

  Widget _buildMessage(String content, BuildContext context) {
    return Container(
      alignment: alingment,
      margin: margin,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10),
          bottomLeft: widget.isAIMsg ? const Radius.circular(0) : const Radius.circular(10),
            topRight: const Radius.circular(10),
          bottomRight: widget.isAIMsg ? const Radius.circular(10) : const Radius.circular(0)
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9 * 0.95),
        child: SelectableText(
          content,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 16,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}

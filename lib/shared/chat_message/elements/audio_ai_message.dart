import 'package:app2/shared/conversation/domain/conversation.dart';
import 'package:app2/shared/chat_message/domain/chat_message.dart';
import 'package:app2/shared/text_to_speech/domain/tts.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'dart:developer';

class AudioAIMessage extends StatefulWidget implements ChatMessageInterface {
  final TextToSpeechInterface _tts = KiwiContainer().resolve<TextToSpeechInterface>();
  bool _isPlaying = false;

  String displayText = "";
  final Stream<String>? textStream;
  final Function()scrollToBottom;
  bool isStreamDone = false;

  @override
  String getRole() {
    return ChatCompletionMessage.roleAssistant;
  }

  @override
  String getContent() {
    return displayText;
  }

  AudioAIMessage(
      {super.key, required this.textStream, required this.scrollToBottom});

  AudioAIMessage.withoutStream({super.key, required this.displayText, required this.scrollToBottom})
        : textStream = null,
          isStreamDone = true;

  @override
  _AudioAIMessageState createState() => _AudioAIMessageState();
}

class _AudioAIMessageState extends State<AudioAIMessage> {
  late Color color;

  @override
  void initState() {
    super.initState();
    color = DarkTheme.primary;

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
      }, onError: (error) {
        log('Error: $error');
      });

      widget.isStreamDone = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 3, right: 8, bottom: 3),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.99),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
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
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(0),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.99 * 0.95),
                  child: SelectableText(
                    widget.displayText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.speaker,
                color: widget._isPlaying ? Colors.redAccent : DarkTheme.secondary,
              ),
              onPressed: () async {
                if (!widget.isStreamDone) {
                  return;
                }

                setState(() {
                  widget._isPlaying = true;
                });

                await widget._tts.playText(widget.displayText);

                setState(() {
                  widget._isPlaying = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:app2/shared/helpers/helpers.dart';
import 'package:app2/shared/text_to_speech/domain/tts.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'dart:developer';

class AudioAIMessage extends StatefulWidget {
  final TextToSpeechInterface _tts = KiwiContainer().resolve<TextToSpeechInterface>();
  bool _isPlaying = false;

  String displayText = "";
  final Stream<String>? textStream;
  final Function()scrollToBottom;
  bool isStreamDone = false;

  AudioAIMessage(
      {super.key, required this.textStream, required this.scrollToBottom});

  @override
  _AudioAIMessageState createState() => _AudioAIMessageState();
}

class _AudioAIMessageState extends State<AudioAIMessage> {
  late Color color;
  late EdgeInsets margin;

  @override
  void initState() {
    super.initState();
    color = DarkTheme.primary;
    margin = const EdgeInsets.only(left: 10, top: 10, right: 70, bottom: 0);

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
    return _buildMessage(widget.displayText, context);
  }

  Widget _buildMessage(String content, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 0, right: 8, bottom: 0),
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
                // margin: margin,
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
                    content,
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

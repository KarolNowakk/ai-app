import 'package:app2/shared/conversation/domain/conversation.dart';
import 'package:app2/shared/chat_message/domain/chat_message.dart';
import 'package:app2/shared/text_to_speech/domain/tts.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiwi/kiwi.dart';
import 'dart:developer';

class ChatMessage extends StatefulWidget {
  final TextToSpeechInterface _tts = KiwiContainer().resolve<TextToSpeechInterface>();
  final String content;
  final bool _isAI;

  ChatMessage.aiMessage({super.key,  required this.content}) : _isAI = true;
  ChatMessage.userMessage({super.key,  required this.content}) : _isAI = false;

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _playAudio() async {
    await widget._tts.playText(widget.content);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget._isAI ? 8 : 40,
        top: 8,
        right: widget._isAI ? 40 : 8,
        bottom: 3,
      ),
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(
          left: 10.0,
          right: 5.0,
          top: 10.0,
          bottom: 5.0,
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
          color: widget._isAI ? DarkTheme.primary : DarkTheme.secondary,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10),
            bottomLeft: widget._isAI ? const Radius.circular(0) : const Radius.circular(10),
            topRight: const Radius.circular(10),
            bottomRight: widget._isAI ? const Radius.circular(10) : const Radius.circular(0),
          ),
        ),
        child: Column(
          crossAxisAlignment: widget._isAI ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.99 * 0.95),
              child: SelectableText(
                widget.content,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            const SizedBox(height: 11),
            SizedBox(
              height: 20,
              child: Row(
                children: [
                  MessageActionButton(
                    text: 'Delete',
                    color: widget._isAI ? DarkTheme.secondary : DarkTheme.textColor,
                    action: () async {
                      print("Implement me");
                    },
                  ),
                  MessageActionButton(
                    text: 'Copy',
                    color: widget._isAI ? DarkTheme.secondary : DarkTheme.textColor,
                    action: () => Clipboard.setData(ClipboardData(text: widget.content)),
                  ),
                  MessageActionButton(
                    text: 'Play',
                    color: widget._isAI ? DarkTheme.secondary : DarkTheme.textColor,
                    action: _playAudio,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageActionButton extends StatefulWidget {
  final String text;
  final Future Function() action;
  final Color color;

  const MessageActionButton({
    super.key,
    required this.text,
    required this.action,
    required this.color,
  });

  @override
  State<MessageActionButton> createState() => _MessageActionButtonState();
}

class _MessageActionButtonState extends State<MessageActionButton> {
  bool _isRunning = false;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextButton(
        onPressed: () async {
          setState(() {_isRunning = true;});
          await widget.action();
          setState(() {_isRunning = false;});
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
        ),
        child: Text(
          widget.text,
          style: TextStyle(fontSize: 12, color: widget.color),
        ),
      ),
    );
  }
}


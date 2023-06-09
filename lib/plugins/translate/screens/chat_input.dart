import 'package:app2/shared/elements/record_button.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  final Function() sendAMessage;
  final TextEditingController controller;

  ChatInput({
    required this.sendAMessage,
    required this.controller,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChanged);
  }

  void _onFocusChanged() {
    setState(() {});
  }

  void send() {
    widget.sendAMessage();
    widget.controller.clear();
    _focus.unfocus();
  }

  void getTranscription(String transcription) {
    widget.controller.text = transcription;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 0,
      child: Container(
        color: DarkTheme.primary,
        padding: const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 5),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextField(
                  focusNode: _focus,
                  controller: widget.controller,
                  cursorColor: Colors.white,
                  // Set cursor color to white
                  style: const TextStyle(color: Colors.white),
                  // Set font color to white
                  decoration: const InputDecoration(
                    focusColor: Colors.white,
                    hintText: 'Type your message here...',
                    hintStyle: TextStyle(color: DarkTheme.textColor),
                    // Set hint text color to white
                    border: InputBorder.none,
                  ),
                  onSubmitted: (text) {
                    send();
                    widget.controller.clear();
                  },
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: null,
                ),
              ),
            ),
            IconButtonInput(
              action: send,
              icon: const Icon(
                Icons.send,
                color: DarkTheme.secondary,
                size: 30,
              ),
            ),
            _focus.hasFocus
                ? const SizedBox.shrink()
                : RecordButton(getTranscribedText: getTranscription)
          ],
        ),
      ),
    );
  }
}

class IconButtonInput extends StatelessWidget {
  const IconButtonInput({
    super.key,
    required this.action,
    required this.icon,
  });

  final Function() action;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        side: BorderSide.none,
        padding: EdgeInsets.zero,
        textStyle: const TextStyle(
          color: DarkTheme.textColor,
        ),
      ),
      onPressed: () {
        action();
      },
      child: icon,
    );
  }
}
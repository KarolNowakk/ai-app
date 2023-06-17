import 'dart:developer';
import 'package:app2/shared/conversation/domain/conversation.dart';
import 'package:app2/shared/conversation/interfaces/conversation_provider.dart';
import 'package:app2/shared/elements/record_button.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatInput extends StatefulWidget {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();

  ChatInput({super.key});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  @override
  void initState() {
    super.initState();
    widget._focus.addListener(_onFocusChanged);
  }

  void _onFocusChanged() {
    setState(() {});
  }

  void getTranscription(String transcription) async {
    widget._controller.text = transcription;
    log("HERE: ${widget._controller.text}");
  }

  void send() {
    widget._controller.clear();
    widget._focus.unfocus();
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
                  focusNode: widget._focus,
                  controller: widget._controller,
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
                    widget._controller.clear();
                  },
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: null,
                ),
              ),
            ),
            GestureDetector(
              onLongPress: context.read<ConversationProvider>().stopStream,
              child: IconButtonInput(
                action: () {
                  context.read<ConversationProvider>().addMessage(
                      ChatCompletionMessage.roleUser, widget._controller.text);
                  widget._controller.text = "";
                },
                icon: const Icon(
                  Icons.send,
                  color: DarkTheme.secondary,
                  size: 30,
                ),
              ),
            ),
            widget._focus.hasFocus
                ? const SizedBox.shrink()
                : RecordButton(getTranscribedText: getTranscription),
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

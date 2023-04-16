import 'package:app2/plugins/lang/screens/style/color.dart';
import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  final Function(String) sendAMessage;
  final TextEditingController controller;

  ChatInput({
    required this.sendAMessage,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: mainColor,
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your message here...',
                    ),
                    onSubmitted: (text) {
                      sendAMessage(text);
                      controller.clear();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    sendAMessage(controller.text);
                    controller.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: accentColor,
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

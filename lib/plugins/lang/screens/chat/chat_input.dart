import 'package:app2/plugins/lang/screens/style/color.dart';
import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  final Function() getNextPrompt;
  final Function(String) sendAMessage;
  final TextEditingController controller;

  ChatInput({
    required this.getNextPrompt,
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
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: getNextPrompt,
                    style: ElevatedButton.styleFrom(
                      primary: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text("Get Next Sentence"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
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

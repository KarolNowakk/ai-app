import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

abstract class SaveWordModalInterface {
  void showSaveWordModal(BuildContext context, String text);
  void hideSaveWorldModal(BuildContext context);
}

class Message extends StatelessWidget {
  final String text;
  final bool isUserMessage;
  final SaveWordModalInterface _saveWordModalController = KiwiContainer().resolve<SaveWordModalInterface>();

  Message({required this.text, required this.isUserMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isUserMessage ? Alignment.centerLeft : Alignment.centerRight,
      margin: isUserMessage
          ? const EdgeInsets.only(left: 10, top: 10, right: 50, bottom: 10)
          : const EdgeInsets.only(left: 50, top: 10, right: 10, bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: isUserMessage ? Colors.grey.withAlpha(200) : Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9 * 0.95),
        child: SelectableText(
          text,
          style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.normal,
              fontSize: 16,
              decoration: TextDecoration.none,
          ),
          onSelectionChanged: (a, b) {
              String selectedText = a.textInside(text);
              sleep(const Duration(seconds: 1));
              _saveWordModalController.showSaveWordModal(context, selectedText);
            },
        ),
      ),
    );
  }
}

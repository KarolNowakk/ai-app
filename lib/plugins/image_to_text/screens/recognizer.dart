import 'package:app2/plugins/image_to_text/application/image_to_text.dart';
import 'package:app2/plugins/lang/screens/chat/chat_input.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';

class TextRecognizerView extends StatefulWidget {
  final Function(String data) func;

  const TextRecognizerView({super.key, required this.func});

  @override
  State<TextRecognizerView> createState() => _TextRecognizerViewState();
}

class _TextRecognizerViewState extends State<TextRecognizerView> {
  final ImageToText _img2Text = ImageToText();

  @override
  Widget build(BuildContext context) {
    return IconButtonInput(
        action: () async {
          String data = await _img2Text.recognize();

          widget.func(data);
        },
        icon: const Icon(Icons.browse_gallery, color: DarkTheme.textColor),
    );
  }}

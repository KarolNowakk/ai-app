import 'package:app2/theme.dart';
import 'package:flutter/material.dart';

class DefaultTextWidget extends StatelessWidget {
  const DefaultTextWidget({
    super.key,
    required TextEditingController controller,
    required String hint,
    ValueChanged<String>? onTextChanged,
  }) : _controller = controller,
      _hint = hint,
      _onTextChanged = onTextChanged;

  final String _hint;
  final TextEditingController _controller;
  final ValueChanged<String>? _onTextChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: _onTextChanged,
      controller: _controller,
      maxLines: null,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
        hintText: _hint,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: DarkTheme.backgroundDarker, // Change this to the desired color
            width: 1.0, // Change this to the desired width
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: DarkTheme.backgroundDarker, // Change this to the desired color
            width: 2.0, // Change this to the desired width
          ),
        ),
      ),
    );
  }
}

import 'package:app2/theme.dart';
import 'package:flutter/material.dart';

class InfinityButton extends StatelessWidget {
  const InfinityButton({
    required this.onPressed,
    required this.text,
    super.key,
  });

  final Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: DarkTheme.primary, width: 1.0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(
              color: DarkTheme.textColor,
            ),
          ),
        ),
      ),
    );
  }
}

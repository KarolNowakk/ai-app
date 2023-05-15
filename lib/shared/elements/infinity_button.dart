import 'package:app2/theme.dart';
import 'package:flutter/material.dart';

class InfinityButton extends StatefulWidget {
  final Function() onPressed;
  final String text;
  final Color? color;

  InfinityButton({
    required this.onPressed,
    required this.text,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  _InfinityButtonState createState() => _InfinityButtonState();
}

class _InfinityButtonState extends State<InfinityButton> {
  bool _isPressed = false;

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: Container(
        decoration: BoxDecoration(
          color: _isPressed ? Colors.grey : widget.color ?? DarkTheme.primary,
          border: Border.all(color: DarkTheme.primary, width: 1.0),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: widget.onPressed,
            child: Text(
              widget.text,
              style: const TextStyle(
                color: DarkTheme.textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

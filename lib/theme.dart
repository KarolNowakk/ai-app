import 'package:flutter/material.dart';

class DarkTheme {
  static const backgroundDarker = Color(0xFF303646);
  static const background = Color(0xFF353b4b);
  static const primary = Color(0xFF454d62);
  static const secondary = Color(0xFF726dff);
  static const textColor = Color(0xFFcccdd1);
  static const error = Colors.redAccent;

  static TextStyle headlineTextStyle = const TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static TextStyle buttonTextStyle = const TextStyle(
    fontSize: 16.0,
    // fontWeight: FontWeight.bold,
    color: textColor,
  );
}

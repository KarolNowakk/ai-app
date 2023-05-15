import 'dart:async';

import 'package:flutter/services.dart';

class FileAccessMacOS {
  static const MethodChannel _channel =
  const MethodChannel('file_access_macos');

  static Future<bool> requestPermission() async {
    final bool result = await _channel.invokeMethod('requestPermission');
    return result;
  }
}

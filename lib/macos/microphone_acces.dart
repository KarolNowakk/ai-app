import 'dart:async';

import 'package:flutter/services.dart';

class MicrophoneAccessMacOS {
  static const MethodChannel _channel =
  const MethodChannel('microphone_access_macos');

  static Future<bool> requestPermission() async {
    // final bool result = await _channel.invokeMethod('requestPermission');
    return true;
  }
}

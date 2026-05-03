import 'dart:async';

import 'package:flutter/services.dart';

class SystemSettings {
  static const MethodChannel _channel = MethodChannel('system_settings');

  static Future<void> dataRoaming() async {
    return await _channel.invokeMethod('data-roaming');
  }
}

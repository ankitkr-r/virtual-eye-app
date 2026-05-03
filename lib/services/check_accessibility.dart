import 'package:flutter/services.dart';

class AccessibilityChecker {
  static const MethodChannel _channel = MethodChannel('system_settings');

  static Future<bool> isAccessibilityEnabled() async {
    try {
      final bool result = await _channel.invokeMethod('isAccessibilityEnabled');
      return result;
    } catch (e) {
      print("Failed to check accessibility: $e");
      return false;
    }
  }
}
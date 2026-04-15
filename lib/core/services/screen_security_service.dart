// File: lib/core/services/screen_security_service.dart
import 'package:flutter/services.dart';

/// Service for preventing screenshots and screen recording
class ScreenSecurityService {
  static const MethodChannel _channel = MethodChannel('mizansir/screen_security');

  /// Enable screen security (prevent screenshots and screen recording)
  Future<void> enableSecurity() async {
    try {
      await _channel.invokeMethod('enableSecurity');
    } catch (e) {
      print('⚠️ Failed to enable screen security: $e');
    }
  }

  /// Disable screen security (allow screenshots and screen recording)
  Future<void> disableSecurity() async {
    try {
      await _channel.invokeMethod('disableSecurity');
    } catch (e) {
      print('⚠️ Failed to disable screen security: $e');
    }
  }
}

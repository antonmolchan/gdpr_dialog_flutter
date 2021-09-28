import 'package:flutter/services.dart';

class GdprDialog {
  static const MethodChannel _channel = const MethodChannel('gdpr_dialog');

  // Create singleton class
  GdprDialog._();
  static final GdprDialog instance = GdprDialog._();

  // Show dialog with asking for get users info for ad
  Future<bool> showDialog({
    bool isForTest = false,
    String testDeviceId = '',
  }) async {
    return await _channel.invokeMethod('gdpr.activate', <String, dynamic>{
          'isForTest': isForTest,
          'testDeviceId': testDeviceId,
        }) ??
        false;
  }

  // Get consent status
  Future<String> getConsentStatus() async {
    final String result = await _channel.invokeMethod('gdpr.getConsentStatus', []) ?? '';
    return result;
  }
}

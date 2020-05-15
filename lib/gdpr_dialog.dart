import 'package:flutter/services.dart';

class GdprDialog {
  static const MethodChannel _channel = const MethodChannel('gdpr_dialog');

  // Create singltone class
  GdprDialog._();
  static final GdprDialog instance = GdprDialog._();

  // Show dialog with asking for get users info for add
  Future<bool> showDialog(String publisherId, String privacyUrl, {bool isForTest = false, String testDeviceId = ''}) {
    return _channel.invokeMethod("gdpr.activate", <String, dynamic>{
      'publisherId': publisherId,
      'privacyUrl': privacyUrl,
      'isForTest': isForTest,
      'testDeviceId': testDeviceId,
    });
  }

  // Set consent status to UNKNOWN
  Future<bool> setConsentToUnknown() {
    return _channel.invokeMethod("gdpr.setUnknown", []);
  }
}

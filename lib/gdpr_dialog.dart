import 'package:flutter/services.dart';

class GdprDialog {
  static const MethodChannel _channel = const MethodChannel('gdpr_dialog');

  // Create singltone class
  GdprDialog._();
  static final GdprDialog instance = GdprDialog._();

  // Show dialog with asking for get users info for add
  Future<dynamic> showDialog(String publisherId, String privacyUrl,
      {bool isForTest = false, String testDeviceId = ''}) {
    return _channel.invokeMethod('gdpr.activate', <String, dynamic>{
      'publisherId': publisherId,
      'privacyUrl': privacyUrl,
      'isForTest': isForTest,
      'testDeviceId': testDeviceId,
    });
  }

  // Set consent status to UNKNOWN
  Future<dynamic> setConsentToUnknown() {
    return _channel.invokeMethod('gdpr.setUnknown', []);
  }

  // Set consent status to NON PERSONAL
  Future<dynamic> setConsentToNonPersonal() {
    return _channel.invokeMethod('gdpr.setConsentToNonPersonal', []);
  }

  // Set consent status to PERSONAL
  Future<dynamic> setConsentToPersonal() {
    return _channel.invokeMethod('gdpr.setConsentToPersonal', []);
  }

  // Get consent status
  Future<dynamic> getConsentStatus() {
    return _channel.invokeMethod('gdpr.getConsentStatus', []);
  }

  // Is user inEEA
  Future<dynamic> isRequestLocationInEea(String publisherId) {
    return _channel.invokeMethod('gdpr.requestLocation', <String, dynamic>{
      'publisherId': publisherId,
    });
  }
}

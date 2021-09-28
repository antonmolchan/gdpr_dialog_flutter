import 'package:flutter/services.dart';

/// Class for work with native GDPR Consent Form
/// and for work with Consent Statuses
class GdprDialog {
  static const MethodChannel _channel = const MethodChannel('gdpr_dialog');

  // Create singleton class
  GdprDialog._();
  static final GdprDialog instance = GdprDialog._();

  /// Requests showing of a native Consent Form for user.
  /// Form consists of Consent Message and buttons:
  /// [Consent], [Do not consent]
  ///
  /// Function returns `true` if
  /// Consent Form loaded (but not required to be shown)
  ///
  /// returns `false` because of
  /// error during loading of Consent Form
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

  /// Possible returned values:
  ///
  /// `OBTAINED` status means, that user already chose one of the variants ('Consent'
  /// or 'Do not consent');
  ///
  /// `REQUIRED` status means, that form should be shown by user, because his
  /// location is at EEA or UK;
  ///
  /// `NOT_REQUIRED` status means, that form would not be shown by user, because his
  /// location is not at EEA or UK;
  ///
  /// `UNKNOWN` status means, that there is no information about user location.
  Future<String> getConsentStatus() async {
    final String result = await _channel.invokeMethod('gdpr.getConsentStatus', []) ?? '';
    return result;
  }
}

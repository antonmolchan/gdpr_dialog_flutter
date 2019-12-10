import 'dart:io';

import 'package:flutter/services.dart';

class GdprDialog {
  static const MethodChannel _channel = const MethodChannel('gdpr_dialog');

  // Create singltone class
  static final GdprDialog _speech = GdprDialog._internal();
  factory GdprDialog() => _speech;
  GdprDialog._internal();

  // Show dialog with asking for get users info for add
  // ignore: missing_return
  Future<bool> showDialog(String publisherId, String privacyUrl, {bool isForTest = false}) {
    if (Platform.isAndroid) {
      return _channel.invokeMethod("gdpr.activate", <String, dynamic>{
        'publisherId': publisherId,
        'privacyUrl': privacyUrl,
        'isForTest': isForTest,
      });
    }
  }
}

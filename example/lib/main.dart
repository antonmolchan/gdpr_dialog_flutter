import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gdpr_dialog/gdpr_dialog.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    GdprDialog()
        .showDialog('pub-2111344032223404', 'https://plus1s.com/privacy-policy/', isForTest: true, testDeviceId: '')
        .then((onValue) {
      print('result === $onValue');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}

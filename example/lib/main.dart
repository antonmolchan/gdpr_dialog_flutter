import 'package:flutter/material.dart';
import 'package:gdpr_dialog/gdpr_dialog.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                child: Text('show dialog'),
                onPressed: () {
                  GdprDialog.instance
                      .showDialog('pub-2111344032223404', 'https://plus1s.com/privacy-policy/', isForTest: true, testDeviceId: '')
                      .then((onValue) {
                    print('result === $onValue');
                  });
                },
              ),
              RaisedButton(
                child: Text('set consent to unknown'),
                onPressed: () => GdprDialog.instance.setConsentToUnknown(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

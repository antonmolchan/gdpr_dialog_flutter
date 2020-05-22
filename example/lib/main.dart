import 'package:flutter/material.dart';
import 'package:gdpr_dialog/gdpr_dialog.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String status = 'none';

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
                      .showDialog(
                          'pub-2111344032223404', 'https://plus1s.com/privacy-policy/' /*, isForTest: true, testDeviceId: ''*/)
                      .then((onValue) {
                    setState(() => status = 'dialog result == $onValue');
                  });
                },
              ),
              RaisedButton(
                child: Text('set consent to unknown'),
                onPressed: () => GdprDialog.instance
                    .setConsentToUnknown()
                    .then((value) => setState(() => status = 'consent status set to unknown')),
              ),
              RaisedButton(
                child: Text('get consent status'),
                onPressed: () =>
                    GdprDialog.instance.getConsentStatus().then((value) => setState(() => status = 'consent status == $value')),
              ),
              RaisedButton(
                child: Text('Is user from Eea ?'),
                onPressed: () => GdprDialog.instance
                    .isRequestLocationInEea('pub-2111344032223404')
                    .then((value) => setState(() => status = 'is user from Eea == $value')),
              ),
              Container(height: 50),
              Text(status),
            ],
          ),
        ),
      ),
    );
  }
}

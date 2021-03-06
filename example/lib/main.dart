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
              ElevatedButton(
                child: Text('show dialog'),
                onPressed: () {
                  GdprDialog.instance
                      .showDialog('pub-2111344032223404', 'https://plus1s.com/privacy-policy/',
                          isForTest: true, testDeviceId: '')
                      .then((onValue) {
                    setState(() => status = 'dialog result == $onValue');
                  });
                },
              ),
              ElevatedButton(
                child: Text('set consent to unknown'),
                onPressed: () => GdprDialog.instance
                    .setConsentToUnknown()
                    .then((value) => setState(() => status = 'consent status set to unknown')),
              ),
              ElevatedButton(
                child: Text('set consent to non personal'),
                onPressed: () => GdprDialog.instance
                    .setConsentToNonPersonal()
                    .then((value) => setState(() => status = 'consent status set to non personal')),
              ),
              ElevatedButton(
                child: Text('set consent to personal'),
                onPressed: () => GdprDialog.instance
                    .setConsentToPersonal()
                    .then((value) => setState(() => status = 'consent status set to personal')),
              ),
              ElevatedButton(
                child: Text('get consent status'),
                onPressed: () => GdprDialog.instance
                    .getConsentStatus()
                    .then((value) => setState(() => status = 'consent status == $value')),
              ),
              ElevatedButton(
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

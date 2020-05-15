## GDPR dialog


 showDialog method get admob publisherID and privacy string url of your site.
 Then get request native to android/ios dialog and set result as boolean.
 
Bool variable "isForTest" for testing library, set true to activate setDebugGeography. (works only for Android)

 In release build set false or delete this argument!
 
 true = show personalized ads
 
 false = show non personalized ads
  
### Usage

```
GdprDialog.instance.showDialog('pub-2111344032223404', 'https://plus1s.com/privacy-policy/', isForTest: true, testDeviceId: '')
                      .then((onValue) {
                    print('result === $onValue');
                  });
```

In the release build, you only need the first two parameters.

The setConsentToUnknown method sets the consent status to UNKNOW

In iOS, if you call showDialog () a second time, it will be shown and the user can change their consent option, for Android I added setConsentToUnknown (), which resets the user’s consent status.

### Usage

```
GdprDialog.instance.setConsentToUnknown();
```


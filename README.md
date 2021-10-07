## GDPR dialog

"showDialog()" calling: gets native request to android/ios Consent Form dialog and sets result as boolean:
- true = requested Consent Form loaded (but may not be shown);
- false = error with Consent Form loading.
 
Bool variable "isForTest" for testing library, set true to activate setDebugGeography. (works only for Android)
In release build set false or delete this argument!

"testDeviceId" you can find in logs.

If user already chose one of Consent Form variants and call it a second time:
 - in iOS form will be shown and the user can change their consent option;
 - in Android form will not be shown. ***To reset the choice*** user need to reinstall the app.

### Usage

```
GdprDialog.instance.showDialog(isForTest: true, testDeviceId: 'xxxxxxxxxxxxxxx')
                      .then((onValue) {
                    print('result === $onValue');
                  });
```

In the release build, you only does not need a parameters.


#### Method getConsentStatus() that return consent status

### Usage

```
GdprDialog.instance.getConsentStatus();
```

It will return string of consent status:
- OBTAINED
- REQUIRED
- NOT_REQUIRED
- UNKNOWN

### Statuses explaining
API, which depends on Android v2 Embedding, can not show you the real status of personalized ad.

 - OBTAINED status means, that user already chose one of the variants ('Consent' or 'Do not consent');
 - REQUIRED status means, that form should be shown by user, because his location is at EEA or UK;
 - NOT_REQUIRED status means, that form would not be shown by user, because his location is not at EEA or UK;
 - UNKNOWN status means, that there is no information about user location.

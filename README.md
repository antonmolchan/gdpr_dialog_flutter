## GDPR dialog


 showDialog method get admob publisherID and privacy string url of your site.
 Then get native request to android/ios dialog and set result as boolean.
- true = show personalized ads
- false = show non personalized ads
 
Bool variable "isForTest" for testing library, set true to activate setDebugGeography. (works only for Android)
In release build set false or delete this argument!
  
### Usage

```
GdprDialog.instance.showDialog('pub-2111344032223404', 'https://plus1s.com/privacy-policy/', isForTest: true, testDeviceId: '')
                      .then((onValue) {
                    print('result === $onValue');
                  });
```

In the release build, you only need the first two parameters.

#### The setConsentToUnknown method sets the consent status to UNKNOW

In iOS, if you call showDialog() a second time, it will be shown and the user can change their consent option, for Android I added setConsentToUnknown(), which resets the user’s consent status.

### Usage

```
GdprDialog.instance.setConsentToUnknown();
```

#### The setConsentToNonPersonal method sets the consent status to NON_PERSONAL

### Usage

```
GdprDialog.instance.setConsentToNonPersonal();
```


#### Method getConsentStatus() that return consent status

### Usage

```
GdprDialog.instance.getConsentStatus();
```

It will return string of consent status:
- PERSONALIZED
- NON_PERSONALIZED
- UNKNOWN


#### One more method isRequestLocationInEea() that return is user in Eea location

### Usage

```
GdprDialog.instance.isRequestLocationInEea(String publisherId);
```

It will return bools:
- true = the user is located in the Eea
- false = the user is not located in the Eea
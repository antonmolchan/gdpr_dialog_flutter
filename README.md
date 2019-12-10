## GDPR dialog

### Works only with Android now!


 showDialog method get admob publisherID and privacy string url of your site.
 Then get request native to android dialog and set result as boolean.
 
Bool variable "isForTest" for testing library, set true to activate setDebugGeography
 In release build set false or delete this argument!
 
 true = show personalized ads
 
 false = show non personalized ads
  
```
  Future<bool> showDialog(String publisherId, String privacyUrl, {bool isForTest = false}) {
    if (Platform.isAndroid) {
      return _channel.invokeMethod("gdpr.activate", <String, dynamic>{
        'publisherId': publisherId,
        'privacyUrl': privacyUrl,
        'isForTest': isForTest,
      });
    }
  }
```
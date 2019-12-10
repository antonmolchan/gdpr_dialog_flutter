## GDPR dialog

### Works only with Android now!


 showDialog method get admob publisherID and privacy string url of your site.
 Then get request native to android dialog and set result as boolean.
 
 true = show personalized ads
 
 false = show non personalized ads
  
```
      Future<bool> showDialog(String publisherId, String privacyUrl) {
        if (Platform.isAndroid) {
          return _channel.invokeMethod("gdpr.activate", <String, dynamic>{
            'publisherId': publisherId,
            'privacyUrl': privacyUrl,
          });
        }
      }
```
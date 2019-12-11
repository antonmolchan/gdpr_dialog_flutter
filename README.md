## GDPR dialog

### Works only with Android now!


 showDialog method get admob publisherID and privacy string url of your site.
 Then get request native to android dialog and set result as boolean.
 
Bool variable "isForTest" for testing library, set true to activate setDebugGeography.

 In release build set false or delete this argument!
 
 true = show personalized ads
 
 false = show non personalized ads
  
## Usage

```
GdprDialog().showDialog('pub-id', 'privacy-policy/', isForTest: false, testDeviceId: '').then((onValue) {
            print(onValue); // result of users choise
});
```

In release build you need only first two parameters.


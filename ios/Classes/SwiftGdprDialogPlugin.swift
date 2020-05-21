import Flutter
import UIKit
import PersonalizedAdConsent

//import PersonalizedAdConsent гугловская библиотека
public class SwiftGdprDialogPlugin: NSObject, FlutterPlugin {
        
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "gdpr_dialog", binaryMessenger: registrar.messenger())
    let instance = SwiftGdprDialogPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch (call.method) {
      case "gdpr.activate":
        let arg = call.arguments as? NSDictionary
        let pubId = arg!["publisherId"] as? String;
        let url = arg!["privacyUrl"] as? String;
        
        self.checkConsent(result: result, publisherId: pubId!, privacyUrl: url!)

       case "gdpr.setUnknown":
        self.setConsentToUnknown(result: result);
        
        case "gdpr.getConsentStatus":
         self.getConsentStatus(result: result);
        
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    private func setConsentToUnknown(result: @escaping FlutterResult) {
        PACConsentInformation.sharedInstance.consentStatus = .unknown;
         print("consent == UNKNOWN");
        result(true);
    }
    
    private func getConsentStatus(result: @escaping FlutterResult) {
        var statusResult = "ERROR"
        let status = PACConsentInformation.sharedInstance.consentStatus
         if status == .nonPersonalized {
            print("nonPersonalized");
            statusResult = "NON_PERSONALIZED"
         } else if status == .personalized {
            print(".personalized");
            statusResult = "PERSONALIZED"
         } else if status == .unknown {
            print(".unknown");
            statusResult = "UNKNOWN"
        }
        
        result(statusResult)
    }

    private func checkConsent(result: @escaping FlutterResult, publisherId: String, privacyUrl: String) {
    
            showConsent(publisherId: publisherId, privacyUrl: privacyUrl) { (bool) in
                print("result IOS ++++++++  " , bool)
                result(bool)
            };

    }
    
    func showConsent(publisherId: String, privacyUrl: String, checkBool : @escaping(Bool) -> Void)
    {
    
        PACConsentInformation.sharedInstance.requestConsentInfoUpdate(
            forPublisherIdentifiers: [publisherId])
        {(_ error: Error?) -> Void in
            if let error = error {
                print("ERROR \(error)")
                checkBool(false)
            } else {
                print("Success GDPG")
                if PACConsentInformation.sharedInstance.isRequestLocationInEEAOrUnknown == true {
                
                let url = URL(string: privacyUrl)!
                let form = PACConsentForm(applicationPrivacyPolicyURL: url)!
                    form.shouldOfferPersonalizedAds = true
                        form.shouldOfferNonPersonalizedAds = true
                
                form.load { (Error) in
                    if Error != nil {
                        checkBool(false)
                        print("ERROR === 1 \(String(describing: Error))")
                    } else  {
                        form.present(from: (UIApplication.shared.delegate?.window?!.rootViewController)!) { (error, user) in
                            if error != nil {
                                checkBool(false)
                            } else {
                                let status = PACConsentInformation.sharedInstance.consentStatus
                                 if status == .nonPersonalized {
                                    print("nonPersonalized");
                                    checkBool(false)
                                }
                                if status == .personalized{
                                    print("personalized");
                                    checkBool(true)
                                }
                            }
                        }
                    }
                 }
                } else {
                    print("ne iz evropi")
                    checkBool(true)
                }
            }
        }
    }
}

import Flutter
import UIKit

//import PersonalizedAdConsent //гугловская библиотека
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
        let pubId = arg!["publisherId"] as? String
        let url = arg!["privacyUrl"] as? String
        
        let dialogStyle = buildDialogStyle(args: arg)
        let languageCode = arg!["languageCode"] as? String
        self.checkConsent(result: result, publisherId: pubId!, privacyUrl: url!, style: dialogStyle, languageCode: languageCode)

       case "gdpr.setUnknown":
        self.setConsentToUnknown(result: result);
        
        case "gdpr.setConsentToNonPersonal":
         self.setConsentToNonPersonal(result: result);
        
        case "gdpr.getConsentStatus":
         self.getConsentStatus(result: result);
        
        case "gdpr.setConsentToPersonal":
         self.setConsentToPersonal(result: result);
        
        case "gdpr.requestLocation":
            let arg = call.arguments as? NSDictionary
            let pubId = arg!["publisherId"] as? String;
            
         self.isUserFromEea(result: result, publisherId: pubId!);
        
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    private func setConsentToUnknown(result: @escaping FlutterResult) {
        PACConsentInformation.sharedInstance.consentStatus = .unknown;
         print("consent == UNKNOWN");
        result(true);
    }
    
    private func setConsentToNonPersonal(result: @escaping FlutterResult) {
        PACConsentInformation.sharedInstance.consentStatus = .nonPersonalized;
         print("consent == NON_PERSONAL");
        result(true);
    }
    
    private func setConsentToPersonal(result: @escaping FlutterResult) {
        PACConsentInformation.sharedInstance.consentStatus = .personalized;
         print("consent == PERSONAL");
        result(true);
    }
    
    private func isUserFromEea(result: @escaping FlutterResult,  publisherId: String) {
        
        PACConsentInformation.sharedInstance.requestConsentInfoUpdate(
            forPublisherIdentifiers: [publisherId])
        {(_ error: Error?) -> Void in
            if let error = error {
                print("ERROR \(error)")
                result(false)
            } else {
                result(PACConsentInformation.sharedInstance.isRequestLocationInEEAOrUnknown);
            }
        
    }
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

    private func checkConsent(result: @escaping FlutterResult, publisherId: String, privacyUrl: String, style: EGADialogStyle, languageCode: String?) {
    
            showConsent(publisherId: publisherId, privacyUrl: privacyUrl, style: style, languageCode: languageCode) { (bool) in
                print("result IOS ++++++++  " , bool)
                result(bool)
            };

    }
    
    private func buildDialogStyle(args: NSDictionary?) -> EGADialogStyle {
        let dialogStyle = EGADialogStyle()
        dialogStyle.backgroundColor = args?["backgroundColor"] as? String
        dialogStyle.dialogBorderRadius = (args?["dialogBorderRadius"] as? Int) ?? -1
        dialogStyle.primaryTextColor = args?["primaryTextColor"] as? String
        dialogStyle.secondaryTextColor = args?["secondaryTextColor"] as? String
        dialogStyle.linkColor = args?["linkColor"] as? String
        dialogStyle.buttonColor = args?["buttonColor"] as? String
        dialogStyle.buttonTextColor = args?["buttonTextColor"] as? String
        dialogStyle.buttonBorderRadius = (args?["buttonBorderRadius"] as? Int) ?? -1
        dialogStyle.buttonBorderSize = (args?["buttonBorderSize"] as? Int) ?? -1
        dialogStyle.buttonBorderColor = args?["buttonBorderColor"] as? String
        return dialogStyle
    }
    
    func showConsent(publisherId: String, privacyUrl: String, style: EGADialogStyle, languageCode: String?, checkBool : @escaping(Bool) -> Void)
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
                    
                    form.load(with: style, languageCode: languageCode) { (Error) in
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

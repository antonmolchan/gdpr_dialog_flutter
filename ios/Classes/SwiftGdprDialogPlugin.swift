import Flutter
import UIKit

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

      default:
        result(FlutterMethodNotImplemented)
      }
    }

    private func checkConsent(result: @escaping FlutterResult, publisherId: String, privacyUrl: String) {

        print(publisherId);
        print(privacyUrl);
        
        result(true);
    }

// //   Регистрация ключа для gdpr
//    public static func initGDPR(key: String)
//    {
//           PACConsentInformation.sharedInstance.requestConsentInfoUpdate(
//                    forPublisherIdentifiers: ["вот тут ключ в массиве]")
//                {(_ error: Error?) -> Void in
//                    if let error = error {
//                        print("ERROR \(error)")
//                    } else {
//                        print("Success GDPG")
//                    }
//                }
//    }
//
//
// //      Вызов окна gdpr
//    func showConsent(url : URL ,from : UIViewController,tab : UITabBarController)
//    {
//        guard let privacyUrl = URL(string: Supports.shared.privateURL()),
//            let form = PACConsentForm(applicationPrivacyPolicyURL: url) else {
//                print("incorrect privacy URL.")
//                return
//        }
//        form.shouldOfferPersonalizedAds = true
//        form.shouldOfferNonPersonalizedAds = true
//        form.shouldOfferAdFree = true
//
//        form.load {(_ error: Error?) -> Void in
//            print("Load complete.")
//            if let error = error {
//                // Handle error.
//                print("Error loading form: \(error.localizedDescription)")
//            } else {
//                form.present(from: from) { (error, userPrefersAdFree) in
//                    if let error = error {
//                        print("Maybe its error \(error)")
//                    } else if userPrefersAdFree {
//                        tab.selectedIndex = 4
//                    } else {
//                        // Check the user's consent choice.
//                        let status = PACConsentInformation.sharedInstance.consentStatus
//                    }
//                }
//            }
//        }
//    }
}

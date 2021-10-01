import Flutter
import UIKit
import UserMessagingPlatform // UMP SDK made for Google Mobile Ads

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
        let isTest = arg!["isForTest"] as? Bool;
        let deviceId = arg!["testDeviceId"] as? String;
        
        self.checkConsent(result: result, isForTest: isTest!, testDeviceId: deviceId!)

      case "gdpr.getConsentStatus":
        self.getConsentStatus(result: result);
      case "gdpr.reset":
        self.resetDecision(result: result);
      default:
        result(FlutterMethodNotImplemented)
    }
  }
  
  private func getConsentStatus(result: @escaping FlutterResult) {
    var statusResult = "ERROR"
    do {
      let status = UMPConsentInformation.sharedInstance.consentStatus
      if status == .notRequired {
        print(".notRequired");
        statusResult = "NOT_REQUIRED"
      } else if status == .required {
        print(".required");
        statusResult = "REQUIRED"
      } else if status == .obtained {
        print(".obtained");
        statusResult = "OBTAINED"
      } else if status == .unknown {
        print(".unknown");
        statusResult = "UNKNOWN"
      }
    } catch let error {
      print("Error on getConsentStatus: \(error)")
    }
    result(statusResult)
  }

  private func checkConsent(result: @escaping FlutterResult, isForTest: Bool, testDeviceId: String) {
    let parameters = UMPRequestParameters()
    // Set tag for under age of consent. Here false means users are not under age.
    parameters.tagForUnderAgeOfConsent = false

    if isForTest {
      let debugSettings = UMPDebugSettings()
      debugSettings.testDeviceIdentifiers = [ testDeviceId ]
      debugSettings.geography = UMPDebugGeography.EEA
      parameters.debugSettings = debugSettings
    }

    // Request an update to the consent information.
    UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(
        withParameters: parameters,
        completionHandler: { [self] error in

          // The consent information has updated.
          if error != nil {
            print("Error on requestConsentInfoUpdate: \(error)")
            result(false)
          } else {
            // The consent information state was updated.
            // You are now ready to see if a form is available.
            let formStatus = UMPConsentInformation.sharedInstance.formStatus
            if formStatus == UMPFormStatus.available {
              loadForm(result: result)
            }
          }
        })
  }
  
  private func loadForm(result: @escaping FlutterResult) {
    UMPConsentForm.load(withCompletionHandler: { form, loadError in
      if loadError != nil {
        print("Error on loadForm: \(loadError)")
        result(false)
      } else {
        // Present the form. You can also hold on to the reference to present
        // later.
        if UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatus.required {
          form?.present(
              from: self,
              completionHandler: { dismissError in
                if dismissError != nil {
                  print("Error on loadForm completionHandler: \(loadError)")
                  result(false)
                } else {
                  if UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatus.obtained {
                    // App can start requesting ads.
                  }
                }
              })
        }
        result(true)
      }
    })
  }

  private func resetDecision() {
    do {
      UMPConsentInformation.sharedInstance.reset()
      result(true)
    } catch let error {
      print("Error on resetDecision: \(error)")
      result(false)
    }
  }
}

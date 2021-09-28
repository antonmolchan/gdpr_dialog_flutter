package com.gmail.antonmolchan00.gdpr_dialog;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

import com.google.android.ump.ConsentForm;
import com.google.android.ump.FormError;
import com.google.android.ump.UserMessagingPlatform;
import com.google.android.ump.ConsentInformation;
import com.google.android.ump.ConsentInformation.ConsentStatus;
import com.google.android.ump.ConsentDebugSettings;
import com.google.android.ump.ConsentRequestParameters;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

// Class for work with GDPR Consent Form
// and for work with Consent Statuses
public class GdprDialogPlugin implements FlutterPlugin, ActivityAware, MethodCallHandler {
  private Activity activity;
  private MethodChannel channel;
  private Result result;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "gdpr_dialog");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
    this.activity = activityPluginBinding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    this.activity = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding activityPluginBinding) {
    this.activity = activityPluginBinding.getActivity();
  }

  @Override
  public void onDetachedFromActivity() {
    this.activity = null;
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    this.result = result;
    try {
      if (call.method.equals("gdpr.activate")) {
        boolean isForTest = false;
        String testDeviceId = call.argument("testDeviceId");
        try {
          isForTest = call.argument("isForTest");
        } catch (Exception ignored) {
        }

        initializeForm(isForTest, testDeviceId);
      } else if (call.method.equals("gdpr.getConsentStatus")) {
        getConsentStatus();
      } else {
        result.notImplemented();
      }
    } catch (Exception e) {
      result.error("1", e.getMessage(), e.getStackTrace());
    }
  }

  private void returnResult(Object result) {
    try {
      this.result.success(result);
    } catch (Exception ignored) {
    }
  }

  // Possible returned values:
  //
  // `OBTAINED` status means, that user already chose one of the variants
  // ('Consent' or 'Do not consent');
  //
  // `REQUIRED` status means, that form should be shown by user, because his
  // location is at EEA or UK;
  //
  // `NOT_REQUIRED` status means, that form would not be shown by user, because
  // his location is not at EEA or UK;
  //
  // `UNKNOWN` status means, that there is no information about user location.
  private void getConsentStatus() {
    String resultStatus = "ERROR";
    ConsentInformation consentInformation = UserMessagingPlatform.getConsentInformation(activity.getBaseContext());
    int consentStatus = consentInformation.getConsentStatus();
    switch (consentStatus) {
      case ConsentStatus.UNKNOWN:
        resultStatus = "UNKNOWN";
        break;
      case ConsentStatus.OBTAINED:
        resultStatus = "OBTAINED";
        break;
      case ConsentStatus.REQUIRED:
        resultStatus = "REQUIRED";
        break;
      case ConsentStatus.NOT_REQUIRED:
        resultStatus = "NOT_REQUIRED";
        break;
    }
    returnResult(resultStatus);
  }

  public void initializeForm(boolean isForTest, String testDeviceId) {
    ConsentRequestParameters requestParams;

    if (isForTest) {
      ConsentDebugSettings debugSettings = new ConsentDebugSettings.Builder(activity.getBaseContext())
          .setDebugGeography(ConsentDebugSettings.DebugGeography.DEBUG_GEOGRAPHY_EEA)
          .addTestDeviceHashedId(testDeviceId).build();
      requestParams = new ConsentRequestParameters.Builder().setConsentDebugSettings(debugSettings)
          .setTagForUnderAgeOfConsent(false).build();
    } else {
      // Set tag for underage of consent. false means users are not underage.
      requestParams = new ConsentRequestParameters.Builder().setTagForUnderAgeOfConsent(false).build();
    }

    ConsentInformation consentInformation = UserMessagingPlatform.getConsentInformation(activity.getBaseContext());
    consentInformation.requestConsentInfoUpdate(activity, requestParams,
        new ConsentInformation.OnConsentInfoUpdateSuccessListener() {
          @Override
          public void onConsentInfoUpdateSuccess() {
            // The consent information state was updated.
            // You are now ready to check if a form is available.
            if (consentInformation.isConsentFormAvailable()) {
              loadForm(consentInformation);
              returnResult(true);
            } else {
              returnResult(false);
            }
          }
        }, new ConsentInformation.OnConsentInfoUpdateFailureListener() {
          @Override
          public void onConsentInfoUpdateFailure(@Nullable FormError formError) {
            GdprDialogPlugin.this.result.error(String.valueOf(formError.getErrorCode()), formError.getMessage(), "");
          }
        });
  }

  public void loadForm(ConsentInformation consentInformation) {
    UserMessagingPlatform.loadConsentForm(activity, new UserMessagingPlatform.OnConsentFormLoadSuccessListener() {
      @Override
      public void onConsentFormLoadSuccess(ConsentForm consentForm) {
        if (consentInformation.getConsentStatus() == ConsentInformation.ConsentStatus.REQUIRED) {
          consentForm.show(activity, new ConsentForm.OnConsentFormDismissedListener() {
            @Override
            public void onConsentFormDismissed(@Nullable FormError formError) {
              // Handle dismissal by reloading form.
              loadForm(consentInformation);
            }
          });
        }
      }
    }, new UserMessagingPlatform.OnConsentFormLoadFailureListener() {
      @Override
      public void onConsentFormLoadFailure(FormError formError) {
        GdprDialogPlugin.this.result.error(String.valueOf(formError.getErrorCode()), formError.getMessage(), "");
      }
    });
  }
}

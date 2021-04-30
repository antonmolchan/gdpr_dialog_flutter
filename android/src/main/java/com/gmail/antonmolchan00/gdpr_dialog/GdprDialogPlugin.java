package com.gmail.antonmolchan00.gdpr_dialog;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;


import com.google.ads.consent.ConsentForm;
import com.google.ads.consent.ConsentFormListener;
import com.google.ads.consent.ConsentInfoUpdateListener;
import com.google.ads.consent.ConsentInformation;
import com.google.ads.consent.ConsentStatus;
import com.google.ads.consent.DebugGeography;
import com.google.ads.consent.FormStyle;

import org.jetbrains.annotations.NotNull;

import java.net.MalformedURLException;
import java.net.URL;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;


public class GdprDialogPlugin implements MethodCallHandler {

  private Activity activity;
  private MethodChannel channel;
  private Result result;
  private ConsentForm form;

  private void checkForConsent(String publisherId, final String privacyUrl, boolean isForTest, String testDeviceId, final FormStyle style, final String languageCode) {
    ConsentInformation consentInformation = ConsentInformation.getInstance(activity);
    if (isForTest) {
      ConsentInformation.getInstance(activity).setDebugGeography(DebugGeography.DEBUG_GEOGRAPHY_EEA);
      ConsentInformation.getInstance(activity).addTestDevice(testDeviceId);
    }
    String[] publisherIds = {publisherId}; // id владельца приложения в адмоб
    consentInformation.requestConsentInfoUpdate(publisherIds, new ConsentInfoUpdateListener() {
      @Override
      public void onConsentInfoUpdated(ConsentStatus consentStatus) {
        switch (consentStatus) {
          case PERSONALIZED:
            returnResult(true);
            break;
          case NON_PERSONALIZED:
            returnResult(false);
            break;
          case UNKNOWN:
            if (ConsentInformation.getInstance(activity.getBaseContext()).isRequestLocationInEeaOrUnknown())
              requestConsent(privacyUrl, style, languageCode);
            else
              returnResult(true);
            break;
          default:
            break;
        }
      }

      @Override
      public void onFailedToUpdateConsentInfo(String errorDescription) { }
    });
  }

  private void returnResult (boolean result) {
    try {
    this.result.success(result);
    }catch (Exception ignored){}
  }

  private void requestConsent(String url, FormStyle style, String languageCode) {
    URL privacyUrl = null;
    try {
      privacyUrl = new URL(url);
    } catch (MalformedURLException ignored) { }
    form = new ConsentForm.Builder(activity, privacyUrl)
            .withListener(new ConsentFormListener() {
              @Override
              public void onConsentFormLoaded() {
                if (form != null && !activity.isFinishing()) {
                  form.show();
                } else {
                  returnResult(false);
                }
              }

              @Override
              public void onConsentFormOpened() { }

              @Override
              public void onConsentFormClosed(ConsentStatus consentStatus, Boolean userPrefersAdFree) {
                switch (consentStatus) {
                  case PERSONALIZED:
                    returnResult(true);
                    break;
                  case NON_PERSONALIZED:
                  case UNKNOWN:
                    returnResult(false);
                    break;
                }
              }

              @Override
              public void onConsentFormError(String errorDescription) {
              }
            })
            .withPersonalizedAdsOption()
            .withNonPersonalizedAdsOption()
            .build();
    form.load(style, languageCode);
  }

  private GdprDialogPlugin(Activity activity, MethodChannel channel) {
    this.channel = channel;
    this.channel.setMethodCallHandler(this);
    this.activity = activity;
  }

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "gdpr_dialog");
    final GdprDialogPlugin plugin = new GdprDialogPlugin(registrar.activity(), channel);
    channel.setMethodCallHandler(plugin);
  }

  private void setConsentToUnknown() {
    ConsentInformation consentInformation = ConsentInformation.getInstance(activity);
    consentInformation.setConsentStatus(ConsentStatus.UNKNOWN);
    try {
      this.result.success(true);
    }catch (Exception ignored){}
  }

  private void setConsentToNonPersonal() {
    ConsentInformation consentInformation = ConsentInformation.getInstance(activity);
    consentInformation.setConsentStatus(ConsentStatus.NON_PERSONALIZED);
    try {
      this.result.success(true);
    }catch (Exception ignored){}
  }

  private void setConsentToPersonal() {
    ConsentInformation consentInformation = ConsentInformation.getInstance(activity);
    consentInformation.setConsentStatus(ConsentStatus.PERSONALIZED);
    try {
      this.result.success(true);
    }catch (Exception ignored){}
  }

  private void getConsentStatus() {
    String resultStatus = "ERROR";
    ConsentInformation consentInformation = ConsentInformation.getInstance(activity);
    ConsentStatus status = consentInformation.getConsentStatus();
    switch (status) {
      case PERSONALIZED:
        resultStatus = "PERSONALIZED";
        break;
      case NON_PERSONALIZED:
        resultStatus = "NON_PERSONALIZED";
        break;
      case UNKNOWN:
        resultStatus = "UNKNOWN";
        break;
    }
    try {
      this.result.success(resultStatus);
    }catch (Exception ignored){}
  }

  private void isUserFromEea(String publisherId, final Result result) {
    String[] publisherIds = {publisherId};
    final boolean[] isFromEurope = {false};
    final ConsentInformation consentInformation = ConsentInformation.getInstance(activity);
    consentInformation.requestConsentInfoUpdate(publisherIds, new ConsentInfoUpdateListener() {
      @Override
      public void onConsentInfoUpdated(ConsentStatus consentStatus) {
        isFromEurope[0] = consentInformation.isRequestLocationInEeaOrUnknown();
        try {
          result.success(isFromEurope[0]);
        }catch (Exception ignored){}
      }
      @Override
      public void onFailedToUpdateConsentInfo(String reason) {

      }
    });
  }

  @NotNull
  private FormStyle getStyle(@NotNull MethodCall call){
    FormStyle formStyle = new FormStyle();
    String backgroundColor = call.argument("backgroundColor");
    formStyle.setBackgroundColor(backgroundColor);
    Integer dialogBorderRadius = call.argument("dialogBorderRadius");
    formStyle.setDialogBorderRadius(dialogBorderRadius);
    String primaryTextColor = call.argument("primaryTextColor");
    formStyle.setPrimaryTextColor(primaryTextColor);
    String secondaryTextColor = call.argument("secondaryTextColor");
    formStyle.setSecondaryTextColor(secondaryTextColor);
    String linkColor = call.argument("linkColor");
    formStyle.setLinkColor(linkColor);
    String buttonColor = call.argument("buttonColor");
    formStyle.setButtonColor(buttonColor);
    String buttonTextColor = call.argument("buttonTextColor");
    formStyle.setButtonTextColor(buttonTextColor);
    Integer buttonBorderRadius = call.argument("buttonBorderRadius");
    formStyle.setButtonBorderRadius(buttonBorderRadius);
    Integer buttonBorderSize = call.argument("buttonBorderSize");
    formStyle.setButtonBorderSize(buttonBorderSize);
    String buttonBorderColor = call.argument("buttonBorderColor");
    formStyle.setButtonBorderColor(buttonBorderColor);
    return formStyle;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
      this.result = result;
    if (call.method.equals("gdpr.activate")) {
      boolean isForTest = false;
      String publisherId = call.argument("publisherId");
      String privacyUrl = call.argument("privacyUrl");
      String testDeviceId = call.argument("testDeviceId");
      try { isForTest = call.argument("isForTest");
      }catch (Exception ignored){}

      FormStyle formStyle = getStyle(call);
      String languageCode = call.argument("languageCode");

      checkForConsent(publisherId, privacyUrl, isForTest, testDeviceId, formStyle, languageCode);

    } else if (call.method.equals("gdpr.setUnknown")){
      setConsentToUnknown();
    } else if (call.method.equals("gdpr.getConsentStatus")) {
      getConsentStatus();
    } else if (call.method.equals("gdpr.requestLocation")) {
      String publisherId = call.argument("publisherId");
      isUserFromEea(publisherId, result);
    } else if (call.method.equals("gdpr.setConsentToNonPersonal")){
      setConsentToNonPersonal();
    } else if (call.method.equals("gdpr.setConsentToPersonal")){
      setConsentToPersonal();
    } else {
      result.notImplemented();
    }
  }
}


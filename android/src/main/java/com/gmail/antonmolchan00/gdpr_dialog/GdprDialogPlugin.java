package com.gmail.antonmolchan00.gdpr_dialog;

import android.app.Activity;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.util.Log;
import android.view.View;


import com.google.ads.consent.ConsentForm;
import com.google.ads.consent.ConsentFormListener;
import com.google.ads.consent.ConsentInfoUpdateListener;
import com.google.ads.consent.ConsentInformation;
import com.google.ads.consent.ConsentStatus;
import com.google.ads.consent.DebugGeography;

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
  private Result dialogResult;
  private ConsentForm form;

  private void checkForConsent(String publisherId, final String privacyUrl) {
    ConsentInformation consentInformation = ConsentInformation.getInstance(activity);
    ConsentInformation.getInstance(activity).addTestDevice("4AB7E57C35ACF6F18F67C9D4A9235B6E");
    ConsentInformation.getInstance(activity).setDebugGeography(DebugGeography.DEBUG_GEOGRAPHY_EEA);
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
              requestConsent(privacyUrl);
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
    dialogResult.success(result);
  }

  private void requestConsent(String url) {
    URL privacyUrl = null;
    try {
      privacyUrl = new URL(url);
    } catch (MalformedURLException ignored) { }
    form = new ConsentForm.Builder(activity, privacyUrl)
            .withListener(new ConsentFormListener() {
              @Override
              public void onConsentFormLoaded() {
                if (form != null)
                  form.show();
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
                    returnResult(false);
                    break;
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
    form.load();
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

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("gdpr.activate")) {
      dialogResult = result;

      String publisherId = call.argument("publisherId");
      String privacyUrl = call.argument("privacyUrl");

      checkForConsent(publisherId, privacyUrl);

    } else {
      result.notImplemented();
    }
  }
}

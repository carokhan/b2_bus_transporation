package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import io.flutter.Log;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry;

/**
 * Generated file. Do not edit.
 * This file is generated by the Flutter tool based on the
 * plugins that support the Android platform.
 */
@Keep
public final class GeneratedPluginRegistrant {
  private static final String TAG = "GeneratedPluginRegistrant";
  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
    ShimPluginRegistry shimPluginRegistry = new ShimPluginRegistry(flutterEngine);
    try {
      flutterEngine.getPlugins().add(new im.nfc.flutter_nfc_kit.FlutterNfcKitPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin flutter_nfc_kit, im.nfc.flutter_nfc_kit.FlutterNfcKitPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.googlesignin.GoogleSignInPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin google_sign_in_android, io.flutter.plugins.googlesignin.GoogleSignInPlugin", e);
    }
    try {
      me.andisemler.nfc_in_flutter.NfcInFlutterPlugin.registerWith(shimPluginRegistry.registrarFor("me.andisemler.nfc_in_flutter.NfcInFlutterPlugin"));
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin nfc_in_flutter, me.andisemler.nfc_in_flutter.NfcInFlutterPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.nfcmanager.NfcManagerPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin nfc_manager, io.flutter.plugins.nfcmanager.NfcManagerPlugin", e);
    }
  }
}

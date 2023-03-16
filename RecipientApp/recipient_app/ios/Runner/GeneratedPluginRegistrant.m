//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<flutter_nfc_kit/FlutterNfcKitPlugin.h>)
#import <flutter_nfc_kit/FlutterNfcKitPlugin.h>
#else
@import flutter_nfc_kit;
#endif

#if __has_include(<nfc_manager/NfcManagerPlugin.h>)
#import <nfc_manager/NfcManagerPlugin.h>
#else
@import nfc_manager;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FlutterNfcKitPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterNfcKitPlugin"]];
  [NfcManagerPlugin registerWithRegistrar:[registry registrarForPlugin:@"NfcManagerPlugin"]];
}

@end

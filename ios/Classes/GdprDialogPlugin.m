#import "GdprDialogPlugin.h"
#import <gdpr_dialog/gdpr_dialog-Swift.h>

@implementation GdprDialogPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGdprDialogPlugin registerWithRegistrar:registrar];
}
@end

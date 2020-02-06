#import "SmsListenerPlugin.h"
#if __has_include(<sms_listener/sms_listener-Swift.h>)
#import <sms_listener/sms_listener-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "sms_listener-Swift.h"
#endif

@implementation SmsListenerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSmsListenerPlugin registerWithRegistrar:registrar];
}
@end

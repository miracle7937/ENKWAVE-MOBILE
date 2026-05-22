#import "EtopPosPlugin.h"
#if __has_include(<etop_pos_plugin/etop_pos_plugin-Swift.h>)
#import <etop_pos_plugin/etop_pos_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "etop_pos_plugin-Swift.h"
#endif

@implementation EtopPosPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftEtopPosPlugin registerWithRegistrar:registrar];
}
@end

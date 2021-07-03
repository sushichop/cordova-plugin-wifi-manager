#import "SCPWiFiManagerPlugin.h"
#import <NetworkExtension/NetworkExtension.h>

static const NSInteger kErrorCodeOffset                 = 2000;

typedef NS_ENUM(NSInteger, SCPWiFiManagerPluginErrorCode) {
    SCPWiFiManagerPluginErrorCodeNotIOSDevice           = 100 + kErrorCodeOffset,
    SCPWiFiManagerPluginErrorCodeNotSupportedIOSVersion = 101 + kErrorCodeOffset
};

static NSString *const kErrorMessageNotIOSDevice            = @"not iOS device.";
static NSString *const kErrorMessageNotSupportedIOSVersion  = @"not supported iOS version.";

@interface SCPWiFiManagerPlugin ()

@end

@implementation SCPWiFiManagerPlugin

- (void)connect:(CDVInvokedUrlCommand *)command {
#if TARGET_OS_SIMULATOR
    CDVPluginResult *result = [self p_createPluginErrorResultWithCode:SCPWiFiManagerPluginErrorCodeNotIOSDevice message:kErrorMessageNotIOSDevice];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
#else
    if (@available(iOS 11.0, *)) {
        NSString *ssid = [command argumentAtIndex:0 withDefault:@""];
        NSString *passphrase = [command argumentAtIndex:1 withDefault:@""];
        NEHotspotConfiguration *configuration = [[NEHotspotConfiguration alloc] initWithSSID:ssid passphrase:passphrase isWEP:NO];
        
        [[NEHotspotConfigurationManager sharedManager] applyConfiguration:configuration completionHandler:^(NSError * _Nullable error) {
            if (error) {
                CDVPluginResult *result = [self p_createPluginErrorResultWithCode:error.code message:error.localizedDescription];
                [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            } else {
                CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            }
        }];
        
    } else {
        CDVPluginResult *result = [self p_createPluginErrorResultWithCode:SCPWiFiManagerPluginErrorCodeNotSupportedIOSVersion message:kErrorMessageNotSupportedIOSVersion];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }
#endif
}

- (void)disconnect:(CDVInvokedUrlCommand *)command {
#if TARGET_OS_SIMULATOR
    CDVPluginResult *result = [self p_createPluginErrorResultWithCode:SCPWiFiManagerPluginErrorCodeNotIOSDevice message:kErrorMessageNotIOSDevice];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
#else
    if (@available(iOS 11.0, *)) {
        NSString *ssid = [command argumentAtIndex:0 withDefault:@""];
        [[NEHotspotConfigurationManager sharedManager] removeConfigurationForSSID:ssid];
        
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        
    } else {
        CDVPluginResult *result = [self p_createPluginErrorResultWithCode:SCPWiFiManagerPluginErrorCodeNotSupportedIOSVersion message:kErrorMessageNotSupportedIOSVersion];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }
#endif
}

- (CDVPluginResult *)p_createPluginErrorResultWithCode:(NSInteger)code message:(NSString *)message {
    NSMutableDictionary<NSString *, NSObject *> *dict = [NSMutableDictionary dictionary];
    dict[@"code"] = @(code);
    dict[@"message"] = message;
    return [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
}

@end

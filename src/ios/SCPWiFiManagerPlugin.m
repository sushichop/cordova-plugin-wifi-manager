#import "SCPWiFiManagerPlugin.h"
#import <NetworkExtension/NetworkExtension.h>

static const NSInteger kErrorCodeOffset             = 2000;

typedef NS_ENUM(NSInteger, SCPWiFiManagerPluginError) {
    SCPWiFiManagerPluginErrorNotIOSDevice           = 100,
    SCPWiFiManagerPluginErrorNotSupportedIOSVersion = 101
};

static NSString *const kErrorMessageNotIOSDevice            = @"not iOS device.";
static NSString *const kErrorMessageNotSupportedIOSVersion  = @"not supported iOS version.";

@interface SCPWiFiManagerPlugin ()

@end

@implementation SCPWiFiManagerPlugin

- (void)connect:(CDVInvokedUrlCommand *)command {
    
#if TARGET_OS_SIMULATOR
    CDVPluginResult *result = [self p_createPluginErrorResultWithCode:(SCPWiFiManagerPluginErrorNotIOSDevice + kErrorCodeOffset) message:kErrorMessageNotIOSDevice];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    
#else
    if (@available(iOS 11.0, *)) {
        NSString *ssid = [command argumentAtIndex:0 withDefault:@""];
        NSString *passphrase = [command argumentAtIndex:1 withDefault:@""];
        NEHotspotConfiguration *configuration = [[NEHotspotConfiguration alloc] initWithSSID:ssid passphrase:passphrase isWEP:NO];
        
        [[NEHotspotConfigurationManager sharedManager] applyConfiguration:configuration completionHandler:^(NSError * _Nullable error) {
            if (error) {
                CDVPluginResult *result = [self p_createPluginErrorResultWithCode:(error.code + kErrorCodeOffset) message:error.localizedDescription];
                [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            } else {
                CDVPluginResult *result = [self p_createPluginOKResultWithSSID:ssid passphrase:passphrase];
                [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            }
        }];
        
    } else {
        CDVPluginResult *result = [self p_createPluginErrorResultWithCode:(SCPWiFiManagerPluginErrorNotSupportedIOSVersion + kErrorCodeOffset) message:kErrorMessageNotSupportedIOSVersion];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }
    
#endif
}

- (void)disconnect:(CDVInvokedUrlCommand *)command {
    
#if TARGET_OS_SIMULATOR
    CDVPluginResult *result = [self p_createPluginErrorResultWithCode:(SCPWiFiManagerPluginErrorNotIOSDevice + kErrorCodeOffset) message:kErrorMessageNotIOSDevice];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    
#else
    if (@available(iOS 11.0, *)) {
        NSString *ssid = [command argumentAtIndex:0 withDefault:@""];
        [[NEHotspotConfigurationManager sharedManager] removeConfigurationForSSID:ssid];
        
        CDVPluginResult *result = [self p_createPluginOKResultWithSSID:ssid];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        
    } else {
        CDVPluginResult *result = [self p_createPluginErrorResultWithCode:(SCPWiFiManagerPluginErrorNotSupportedIOSVersion + kErrorCodeOffset) message:kErrorMessageNotSupportedIOSVersion];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }
    
#endif
}

NS_ASSUME_NONNULL_BEGIN

- (CDVPluginResult *)p_createPluginOKResultWithSSID:(NSString *)SSID passphrase:(nullable NSString *)passphrase {
    NSMutableDictionary<NSString *, NSString *> *dict = [NSMutableDictionary dictionary];
    dict[@"ssid"] = SSID;
    if (passphrase != nil) {
        dict[@"passphrase"] = passphrase;
    }
    return [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
}

- (CDVPluginResult *)p_createPluginOKResultWithSSID:(NSString *)SSID {
    return [self p_createPluginOKResultWithSSID:SSID passphrase:nil];
}

- (CDVPluginResult *)p_createPluginErrorResultWithCode:(NSInteger)code message:(NSString *)message {
    NSMutableDictionary<NSString *, NSObject *> *dict = [NSMutableDictionary dictionary];
    dict[@"code"] = @(code);
    dict[@"message"] = message;
    return [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
}

NS_ASSUME_NONNULL_END

@end

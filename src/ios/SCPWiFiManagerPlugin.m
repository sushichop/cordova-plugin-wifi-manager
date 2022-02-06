#import "SCPWiFiManagerPlugin.h"
#import <NetworkExtension/NetworkExtension.h>

static const NSInteger kErrorCodeOffset                 = 2000;

typedef NS_ENUM(NSInteger, SCPWiFiManagerPluginErrorCode) {
    SCPWiFiManagerPluginErrorCodeTooShortPassphrase     =   1 + kErrorCodeOffset,
    SCPWiFiManagerPluginErrorCodeNotIOSDevice           = 100 + kErrorCodeOffset,
    SCPWiFiManagerPluginErrorCodeNotSupportedIOSVersion = 101 + kErrorCodeOffset
};

static NSString *const kErrorMessageTooShortPassphrase      = @"too short passphrase(must be at least 8 characters) for WPA/WPA2 Wi-Fi network.";
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

        if (passphrase.length == 0) {
            NEHotspotConfiguration *configuration = [[NEHotspotConfiguration alloc] initWithSSID:ssid];
            [self p_connectWiFiNetworkWithConfiguration:configuration command:command];
        } else if (passphrase.length > 0 && passphrase.length < 8) {
            CDVPluginResult *result = [self p_createPluginErrorResultWithCode:SCPWiFiManagerPluginErrorCodeTooShortPassphrase message:kErrorMessageTooShortPassphrase];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        } else {
            NEHotspotConfiguration *configuration = [[NEHotspotConfiguration alloc] initWithSSID:ssid passphrase:passphrase isWEP:NO];
            [self p_connectWiFiNetworkWithConfiguration:configuration command:command];
        }
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

- (void)p_connectWiFiNetworkWithConfiguration:(NEHotspotConfiguration *)configuration command:(CDVInvokedUrlCommand *)command{
    [[NEHotspotConfigurationManager sharedManager] applyConfiguration:configuration completionHandler:^(NSError * _Nullable error) {
        if (error) {
            CDVPluginResult *result = [self p_createPluginErrorResultWithCode:error.code message:error.localizedDescription];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        } else {
            CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }
    }];
}

- (CDVPluginResult *)p_createPluginErrorResultWithCode:(NSInteger)code message:(NSString *)message {
    NSMutableDictionary<NSString *, NSObject *> *dict = [NSMutableDictionary dictionary];
    dict[@"code"] = @(code);
    dict[@"message"] = message;
    return [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
}

@end

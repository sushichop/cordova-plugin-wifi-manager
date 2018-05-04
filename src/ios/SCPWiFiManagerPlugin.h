#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>

@interface SCPWiFiManagerPlugin : CDVPlugin

- (void)connect:(CDVInvokedUrlCommand *)command;
- (void)disconnect:(CDVInvokedUrlCommand *)command;

@end

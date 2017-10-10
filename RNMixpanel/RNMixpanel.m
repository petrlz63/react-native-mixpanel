//
//  RNMixpanel.m
//  Dramsclub
//
//  Created by Davide Scalzo on 08/11/2015.
//  Forked by Kevin Hylant on 5/3/2016.
//  Copyright © 2015 Facebook. All rights reserved.
//

#import "RNMixpanel.h"

#import <Mixpanel/Mixpanel.h>

@implementation RNMixpanel

// Expose this module to the React Native bridge
RCT_EXPORT_MODULE()

+ (void)initWithToken:(NSString*)apiToken launchOptions: (NSDictionary *)launchOptions
{
    Mixpanel* instance = [[Mixpanel alloc] initWithToken:apiToken launchOptions:launchOptions flushInterval:60 trackCrashes:NO];
#if defined(DEBUG)
    instance.enableLogging = YES;
#endif
}

// get distinct id
RCT_EXPORT_METHOD(getDistinctId:(RCTResponseSenderBlock)callback) {
    callback(@[[Mixpanel sharedInstance].distinctId ?: @""]);
}

// get superProp
RCT_EXPORT_METHOD(getSuperProperty: (NSString *)prop callback:(RCTResponseSenderBlock)callback) {
    NSDictionary *currSuperProps = [[Mixpanel sharedInstance] currentSuperProperties];

    if ([currSuperProps objectForKey:prop]) {
        NSString *superProp = currSuperProps[prop];
        callback(@[superProp]);
    } else {
        callback(@[[NSNull null]]);
    }
}

// track
RCT_EXPORT_METHOD(track:(NSString *)event) {
    [[Mixpanel sharedInstance] track:event];
}

// track with properties
RCT_EXPORT_METHOD(trackWithProperties:(NSString *)event properties:(NSDictionary *)properties) {
    [[Mixpanel sharedInstance] track:event properties:properties];
}

// flush
RCT_EXPORT_METHOD(flush) {
    [[Mixpanel sharedInstance] flush];
}

// create Alias
RCT_EXPORT_METHOD(createAlias:(NSString *)old_id) {
    [[Mixpanel sharedInstance] createAlias:old_id forDistinctID:mixpanel.distinctId];
}

// identify
RCT_EXPORT_METHOD(identify:(NSString *) uniqueId) {
    [[Mixpanel sharedInstance] identify:uniqueId];
}

// Timing Events
RCT_EXPORT_METHOD(timeEvent:(NSString *)event) {
    [[Mixpanel sharedInstance] timeEvent:event];
}

// Register super properties
RCT_EXPORT_METHOD(registerSuperProperties:(NSDictionary *)properties) {
    [[Mixpanel sharedInstance] registerSuperProperties:properties];
}

// Register super properties Once
RCT_EXPORT_METHOD(registerSuperPropertiesOnce:(NSDictionary *)properties) {
    [[Mixpanel sharedInstance] registerSuperPropertiesOnce:properties];
}

// Init push notification
RCT_EXPORT_METHOD(initPushHandling:(NSString *) token) {
     [self addPushDeviceToken:token];
}

// Set People Data
RCT_EXPORT_METHOD(set:(NSDictionary *)properties) {
    [[Mixpanel sharedInstance].people set:properties];
}

// Set People Data Once
RCT_EXPORT_METHOD(setOnce:(NSDictionary *)properties) {
    [[Mixpanel sharedInstance].people setOnce: properties];
}

// Remove Person's Push Token (iOS-only)
RCT_EXPORT_METHOD(removePushDeviceToken:(NSData *)deviceToken) {
    [[Mixpanel sharedInstance].people removePushDeviceToken:deviceToken];
}

// Remove Person's Push Token (iOS-only)
RCT_EXPORT_METHOD(removeAllPushDeviceTokens) {
    [[Mixpanel sharedInstance].people removeAllPushDeviceTokens];
}

// track Revenue
RCT_EXPORT_METHOD(trackCharge:(nonnull NSNumber *)charge) {
    [[Mixpanel sharedInstance].people trackCharge:charge];
}

// track with properties
RCT_EXPORT_METHOD(trackChargeWithProperties:(nonnull NSNumber *)charge properties:(NSDictionary *)properties) {
    [[Mixpanel sharedInstance].people trackCharge:charge withProperties:properties];
}

// increment
RCT_EXPORT_METHOD(increment:(NSString *)property count:(nonnull NSNumber *)count) {
    [[Mixpanel sharedInstance].people increment:property by:count];
}

// Add Person's Push Token (iOS-only)
RCT_EXPORT_METHOD(addPushDeviceToken:(NSString *)pushDeviceToken) {
    NSMutableData *deviceToken = [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [pushDeviceToken length]/2; i++) {
        byte_chars[0] = [pushDeviceToken characterAtIndex:i*2];
        byte_chars[1] = [pushDeviceToken characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [deviceToken appendBytes:&whole_byte length:1];
    }
    [[Mixpanel sharedInstance].people addPushDeviceToken:deviceToken];
}

// reset
RCT_EXPORT_METHOD(reset) {
    [[Mixpanel sharedInstance] reset];
    NSString *uuid = [[NSUUID UUID] UUIDString];
    [[Mixpanel sharedInstance] identify:uuid];
}

@end

//
//  MiOAuth.h
//  MiOAuth
//
//  Created by ssc on 2017/10/16.
//  Copyright © 2017年 xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOErrorCode.h"

typedef NS_ENUM(NSInteger, MOPlatform) {
    MOPlatformDev = 0,
    MOPlatformShuidi = 1
};

typedef NS_ENUM(NSInteger, MOLoginType) {
    MOLoginTypeTicket = 0,
    MOLoginTypePwd = 1
};

typedef void (^MOCompleteBlock)(id responseObject, NSError *error);

@interface MiOAuth : NSObject

+ (instancetype)sharedInstance;

- (void)setTestEnv:(BOOL)test;

- (void)setupWithPlatform:(MOPlatform)platform
                    appId:(NSString *)appId
              redirectUrl:(NSString *)redirectUrl;

- (void)setupTintColor:(UIColor *)tintColor;
- (void)setupBarTintColor:(UIColor *)barTintColor;

- (void)applyAccessTokenWithPermissions:(NSArray *)permissions
                                  state:(NSString *)state
                          completeBlock:(MOCompleteBlock)block;
- (void)applyAuthCodeWithPermissions:(NSArray *)permissions
                               state:(NSString *)state
                       completeBlock:(MOCompleteBlock)block;
- (void)applyAuthCodeWithPermissions:(NSArray *)permissions
                            deviceId:(NSString *)deviceId
                               state:(NSString *)state
                       completeBlock:(MOCompleteBlock)block;

- (void)doHttpGetWithUrl:(NSString *)url
                  params:(NSDictionary *)params
                  macKey:(NSString *)macKey
           completeBlock:(MOCompleteBlock)block;

- (void)clearCookie;
- (BOOL)handleOpenUrl:(NSURL *)url;
- (void)setLoginType:(MOLoginType)type;

+ (NSString *)generateHMACHeaderWithMethod:(NSString *)method
                                       url:(NSString *)url
                                    params:(NSDictionary *)params
                                    macKey:(NSString *)macKey;

@end

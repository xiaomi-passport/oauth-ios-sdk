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

@property (nonatomic) BOOL skipConfirm;      //默认值为true，授权有效期内的用户在已登录情况下，不显示授权页面，直接通过。如果需要用户每次手动授权，设置为false
@property (nonatomic) MOLoginType loginType; //登录类型，指定登录页面采用短信登录还是密码登录，默认密码方式登录。

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

+ (NSString *)generateHMACHeaderWithMethod:(NSString *)method
                                       url:(NSString *)url
                                    params:(NSDictionary *)params
                                    macKey:(NSString *)macKey;

@end

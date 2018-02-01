//
//  AppDelegate.m
//  MiOAuthDemo
//
//  Created by ssc on 2017/10/18.
//  Copyright © 2017年 xiaomi. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[MiOAuth sharedInstance] setupWithPlatform:MOPlatformDev
                                          appId:@"179887661252608"
                                    redirectUrl:@"http://xiaomi.com"];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    NSLog(@"url: %@, source application: %@, annotation:%@", url, sourceApplication, annotation);
    [[MiOAuth sharedInstance] handleOpenUrl:url];
    return YES;
}

@end

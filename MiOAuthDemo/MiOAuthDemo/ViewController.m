//
//  ViewController.m
//  MiOAuthDemo
//
//  Created by ssc on 2017/10/18.
//  Copyright © 2017年 xiaomi. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@property (nonatomic, strong) NSDictionary *loginInfo;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)getAccessToken:(id)sender
{
    [self applyAccessToken];
}

- (IBAction)getCode:(id)sender
{
    [self applyAuthCode];
}

- (void)applyAccessToken
{
    [[MiOAuth sharedInstance] applyAccessTokenWithPermissions:nil
                                                        state:@"state"
                                                completeBlock:^(id responseObject, NSError *error)
    {
        if(error){
            NSLog(@"Apply AccessToken Error:%@", error);
            return;
        }
        
        NSLog(@"response object:%@", responseObject);
        self.loginInfo = responseObject;
    }];
    

}

- (void)applyAuthCode
{
    [[MiOAuth sharedInstance] applyAuthCodeWithPermissions:nil state:@"state" completeBlock:^(id responseObject, NSError *error)
    {
        if(error){
            NSLog(@"Apply AuthCode Error:%@", error);
            return;
        }
        
        NSLog(@"response object:%@", responseObject);
    }];
}

- (IBAction)getUserInfo:(id)sender
{
    if(!self.loginInfo){
        NSLog(@"No Login Info");
        return;
    }
    
    NSDictionary *params = @{
                             @"clientId":@"179887661252608",
                             @"token":[self.loginInfo objectForKey:@"access_token"]
                             };
    [[MiOAuth sharedInstance] doHttpGetWithUrl:@"https://open.account.xiaomi.com/user/profile"
                                        params:params
                                        macKey:[self.loginInfo objectForKey:@"mac_key"]
                                 completeBlock:^(id responseObject, NSError *error)
    {
        if(error){
            NSLog(@"error:%@", error);
            return;
        }
         
        NSLog(@"result:%@", responseObject);
    }];
}

@end

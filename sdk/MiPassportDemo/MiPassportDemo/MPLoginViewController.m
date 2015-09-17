//
//  MPLoginViewController.m
//  MiPassportDemo
//
//  Created by 李 业 on 13-7-11.
//  Copyright (c) 2013年 李 业. All rights reserved.
//

#import "MPLoginViewController.h"
#import "MiPassport/MiPassport.h"

@interface MPLoginViewController ()
<MPSessionDelegate,
MPRequestDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation MPLoginViewController{
    MiPassport *_passport;
    UIActivityIndicatorView *indicatorView;
}

@synthesize loginBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _passport = [[MiPassport alloc] initWithAppId:@"179887661252608" redirectUrl:@"http://xiaomi.com" andDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginPassport:(id)sender {
    [_passport loginWithPermissions:nil];
}

- (IBAction)retriveCode:(id)sender {
    [_passport applyPassCodeWithPermissions:nil];
}

- (IBAction)getUserInfo:(id)sender {
    [_passport requestWithURL:@"user/profile" params:[NSMutableDictionary dictionaryWithObject:_passport.appId forKey:@"clientId"] httpMethod:@"GET" delegate:self];
}

- (IBAction)getRelations:(id)sender {
    [_passport requestWithURL:@"user/relation" params:[NSMutableDictionary dictionaryWithObject:_passport.appId forKey:@"clientId"] httpMethod:@"GET" delegate:self];
}

- (IBAction)logoutPassport:(id)sender {
    [_passport logOut];
}

#pragma mark - MPSessionDelegate
// 登录成功
- (void)passportDidLogin:(MiPassport *)passport{
    NSLog(@"passport login succeeded, token:%@, token type:%@, expiration date:%@, encrypt algorithm:%@, encrypt key:%@", passport.accessToken, passport.tokenType, passport.expirationDate, passport.encryptAlgorithm, passport.encryptKey);
    NSString *alertMsg = [NSString stringWithFormat:@"Access Token: %@\nToken Type:%@\n", passport.accessToken, passport.tokenType];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Access Token" message: alertMsg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

//登录失败
- (void)passport:(MiPassport *)passport failedWithError:(NSError *)error{
    NSDictionary *errorInfo = [error userInfo];
    NSLog(@"passport login failed with error: %d info %@", [error code], [errorInfo objectForKey: @"error_description"]);
    NSString *alertMsg = [NSString stringWithFormat:@"Error: %@\nDescription:%@\n", [errorInfo objectForKey:@"error"], [errorInfo objectForKey:@"error_description"]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message: alertMsg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

// 用户取消登录
- (void)passportDidCancel:(MiPassport *)passport{
    NSLog(@"passport login did cancel");
}

//登出成功
- (void)passportDidLogout:(MiPassport *)passport{
    NSLog(@"passport did log out");
}

//获取code
- (void)passport:(MiPassport *)passport didGetCode:(NSString *)code{
    NSLog(@"passport did get code: %@", code);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Access Code" message: code delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

//token过期
- (void)passport:(MiPassport *)passport accessTokenInvalidOrExpired:(NSError *)error{
    NSLog(@"passport accesstoken invalid or expired");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Access token invalid or expired!" message: nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark - MPRequestDelegate
// 请求向服务器发送
- (void)requestLoading:(MPRequest *)request{
    NSLog(@"request start loading");
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                     UIActivityIndicatorViewStyleGray];
    indicatorView.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
    | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:indicatorView];
    [indicatorView sizeToFit];
    [indicatorView startAnimating];
    indicatorView.center = self.view.center;
}

// 请求收到服务器回复，开始接受数据
- (void)request:(MPRequest *)request didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"request did receive response");
    [indicatorView stopAnimating];
    indicatorView = nil;
}

// 请求失败， error包含错误信息
- (void)request:(MPRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"request did fail with error code: %d", [error code]);
    if ([request.url hasSuffix:@"user/profile"]) {
        
    }
    else if ([request.url hasSuffix:@"user/relation"]){
        
    }
}

// 请求成功，result为处理后的请求结果
- (void)request:(MPRequest *)request didLoad:(id)result{
    NSLog(@"request did load: %@", result);
    if ([request.url hasSuffix:@"user/profile"]) {
        
    }
    else if ([request.url hasSuffix:@"user/relation"]){
        
    }
}

// 请求成功，data为未经处理的服务器返回数据
- (void)request:(MPRequest *)request didLoadRawResponse:(NSData *)data{
    NSLog(@"request did load raw response: %@", data);
}
@end

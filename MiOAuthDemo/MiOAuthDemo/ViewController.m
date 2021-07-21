//
//  ViewController.m
//  MiOAuthDemo
//
//  Created by key on 2018/7/5.
//  Copyright © 2018年 key. All rights reserved.
//

#import "ViewController.h"
#import <MiOAuth/MiOAuth.h>

@interface ViewController ()

@property (nonatomic, strong) NSDictionary *loginInfo;
@property (nonatomic, weak) IBOutlet UITextView *logView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)getCode:(id)sender {
    [self applyAuthCode];
}

- (void)applyAuthCode {
    [MiOAuth sharedInstance].loginType = MOLoginTypeTicket;
    [MiOAuth sharedInstance].skipConfirm = false;
    [MiOAuth sharedInstance].fullScreenPresent = true;
    [[MiOAuth sharedInstance] applyAuthCodeWithPermissions:nil state:@"state" completeBlock:^(id responseObject, NSError *error)
     {
         if(error){
             NSLog(@"Apply AuthCode Error:%@", error);
             return;
         }
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *code = [responseObject valueForKey:@"code"];
             if(code) {
                 self.logView.text = code;
             }
         });
         NSLog(@"response object:%@", responseObject);
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

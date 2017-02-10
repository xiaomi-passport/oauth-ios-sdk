//
//  MPAppDelegate.h
//  MiPassportDemo
//
//  Created by 李 业 on 13-7-11.
//  Copyright (c) 2013年 李 业. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MiPassport/MiPassport.h>

@interface MPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) MiPassport *passport;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

//
//  AppDelegate.h
//  WyjDemo
//
//  Created by wyj on 15/10/16.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MBProgressHUD/MBProgressHUD.h"
#import "LocationManger.h"

@interface AppDelegate : UIResponder <
UIApplicationDelegate,
UITabBarControllerDelegate,
LocationManagerDelegate
>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) UITabBarController *tabVC;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) NSString *sAddFriendTemplate;
@property (nonatomic,strong) NSString *sShareTemplate;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)updateLastCityID;
- (void)autoLogin;

@end


//
//  AppDelegate.m
//  WyjDemo
//
//  Created by wyj on 15/10/16.
//  Copyright (c) 2015年 wyj. All rights reserved.
//

#import "AppDelegate.h"
//#import "SRWebSocket.h"
//#import "JSONKit.h"
#import "ChatListViewController.h"
#import "SaleViewController.h"
#import "ItemListViewController.h"
#import "UserViewController.h"
#import "Global.h"
#import "ChatTools.h"
#import "LoginEntity.h"
#import "NetworkEngine.h"
#import "ResponseLoginInfo.h"
#import "UserMember.h"
#import "LaunageUtility.h"
#import "NSString+SHA256HMAC.h"
#import "BaseUserInfo.h"
#import "UploadUserInfoEntity.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "RequestAddFriend.h"
#import "ResponseAddFriendTemplate.h"

#import "RequestGetShareTemplate.h"

@interface AppDelegate ()
@property (nonatomic,strong) SaleViewController *saleVC;
@property (nonatomic,strong) ChatListViewController *chatListVC;
@property (nonatomic,strong) UserViewController *userVC;
@property (nonatomic,strong) ItemListViewController *itemlistVC;

@end

@implementation AppDelegate
@synthesize HUD;
@synthesize sAddFriendTemplate;
@synthesize sShareTemplate;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *s = [[NSUserDefaults standardUserDefaults] objectForKey:AppLanguage];
    
    if (s && s.length == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:AppLanguage];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    [self autoLogin];
    
    [self initNotification];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self initTabBar];
    [LocationManger getInstance].delegate = self;
    [[LocationManger getInstance] startUpdataLocation];
    [self.window makeKeyAndVisible];
    [self fetchTemplate];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

-(void)fetchTemplate
{
    RequestAddFriend *request = [[RequestAddFriend alloc] init];
    [NetworkEngine getJSONWithUrl:request success:^(id json) {
        ResponseAddFriendTemplate *response = [[ResponseAddFriendTemplate alloc] initwithJson:json];
        NSLog(@"%@",response.displayName);
        self.sAddFriendTemplate = response.displayName;
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    
    RequestGetShareTemplate *req = [[RequestGetShareTemplate alloc] init];
    [NetworkEngine getJSONWithUrl:req success:^(id json) {
        self.sShareTemplate = [json objectForKey:@"displayName"];
    } fail:^(NSError *error) {
        
    }];
}

-(void)afterUserLogin
{
    if ([UserMember getInstance].isLogin) {
        NSLog(@"Login in Success %@",[UserMember getInstance].userId);
    }
    [[NSUserDefaults standardUserDefaults] setValue:[UserMember getInstance].userId forKey:def_UserId_userDefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[ChatTools getInstance] setToken];
    [[ChatTools getInstance] openSocket];
    
    
    if ([UserMember getInstance].baseUserInfo.lastSelectedCityId && [UserMember getInstance].baseUserInfo.lastSelectedCityId != [NSNull null] && [UserMember getInstance].baseUserInfo.lastSelectedCityId.length > 0) {
        //存在则替换掉本地
        [[NSUserDefaults standardUserDefaults] setValue:[UserMember getInstance].baseUserInfo.lastSelectedCityId forKey:@"localCityId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        //不存在则更新进用户信息里。
        [self updateLastCityID];
    }
}

-(void)updateLastCityID
{
    NSString *sCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"localCityId"];
    if (sCity.length > 0) {
        UploadUserInfoEntity *entity = [[UploadUserInfoEntity alloc] init];
        entity.lastSelectedCityId = sCity;
        [NetworkEngine putUserInfoWithEntity:entity success:^(id json) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"chooseCity"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        } fail:^(NSError *error) {
            
        }];
    }
}


-(void)lmGetLocationFaild:(NSString*)sError
{
    
}

-(void)initNotification{
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afterUserLogin) name:@"openSocketNotification" object:nil];
}

- (void)autoLogin{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"]) {
        LoginEntity *login = [[LoginEntity alloc] init];
        login.email = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
        login.password = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserPWD"];
        login.mobilePlatform = @"IPHONE";
        
        [NetworkEngine postLoginRequestEntity:login success:^(id json) {
            //保存登录信息
            BaseUserInfo *user = [[BaseUserInfo alloc] initWithDic:json];
            [UserMember getInstance].baseUserInfo = user;
            
            [UserMember getInstance].isLogin = YES;
            [UserMember getInstance].userId = user.userId;
            [UserMember getInstance].signingKey = user.signingKey;
            
            [self afterUserLogin];
            
        } fail:^(NSError *error) {
            NSLog(@"login fail %@",error);
        }];
    }
}

-(void)initTabBar
{
    self.tabVC = [[UITabBarController alloc] init];
    self.window.rootViewController = self.tabVC;
    self.tabVC.delegate = self;
    
    self.tabVC.tabBar.tintColor = RGBA(250, 211, 67, 1);//背景颜色bg_tabbar_home
    self.chatListVC = [[ChatListViewController alloc] initWithNibName:@"ChatListViewController" bundle:nil];
    [self.chatListVC.tabBarItem setImage:[UIImage imageNamed:@"xiaoxi"]];
    [self.chatListVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"xiaoxi_on"]];
    UINavigationController *chatListNav = [[UINavigationController alloc] initWithRootViewController:self.chatListVC];
    
    self.saleVC = [[SaleViewController alloc] initWithNibName:@"SaleViewController" bundle:nil];
    [self.saleVC.tabBarItem setImage:[UIImage imageNamed:@"chushou"]];
    [self.saleVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"chushou_on"]];
    UINavigationController *salNav = [[UINavigationController alloc] initWithRootViewController:self.saleVC];
    
    self.itemlistVC = [[ItemListViewController alloc] initWithNibName:@"ItemListViewController" bundle:nil];
    [self.itemlistVC.tabBarItem setImage:[UIImage imageNamed:@"kan"]];
    [self.itemlistVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"kan_on"]];
    UINavigationController *itemlistNav = [[UINavigationController alloc] initWithRootViewController:self.itemlistVC];
    
    self.userVC = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:nil];
    [self.userVC.tabBarItem setImage:[UIImage imageNamed:@"wode"]];
    [self.userVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"wode_on"]];
    UINavigationController *userNav = [[UINavigationController alloc] initWithRootViewController:self.userVC];
    
    //修改图片位置
    self.chatListVC.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    self.saleVC.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    self.itemlistVC.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    self.userVC.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    self.tabVC.viewControllers = @[itemlistNav,chatListNav,salNav,userNav];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        NSLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        NSLog(@"applicationDidEnterBackground");
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"applicationDidBecomeActive");
    [FBSDKAppEvents activateApp];
    if ([ChatTools getInstance]._webSocket) {
        [[ChatTools getInstance]._webSocket close];
    }
    
    [ChatTools getInstance]._webSocket = nil;
    [[ChatTools getInstance] setToken];
    [[ChatTools getInstance] openSocket];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.wyj.WyjDemo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WyjDemo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WyjDemo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end

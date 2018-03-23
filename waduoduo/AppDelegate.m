//
//  AppDelegate.m
//  waduoduo
//
//  Created by 名侯 on 2017/4/20.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import <AVOSCloud.h>
#import <RongIMKit/RongIMKit.h>

#define APP_ID @"7Rm1IitHkHO0a2bUKAKfQIH0-gzGzoHsz"
#define APP_KEY @"r6mw4nLd65uUGGCuN9Lv2kRs"

@interface AppDelegate () <RCIMUserInfoDataSource>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
#pragma mark -- 初始化 LeanClond
    [AVOSCloud setApplicationId:APP_ID clientKey:APP_KEY];//569b3f3de0f55adf5c0008c0
#pragma mark -- 初始化 融云
    [[RCIM sharedRCIM] initWithAppKey:@"3argexb63u8le"];
    NSString *IMtoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"IMtoken"];
    if (![XYString isObjectNull:IMtoken]) {
        [self initRCIMtoken:IMtoken];
    }
    
    MainTabBarController *root = [[MainTabBarController alloc] init];
    self.window.rootViewController = root;
    [self.window makeKeyAndVisible];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    APP_DELE.newV = YES;
    
#pragma mark -- 融云推送
    //注册推送, 用于iOS8以及iOS8之后的系统
    UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                            settingsForTypes:(UIUserNotificationTypeBadge |
                                                              UIUserNotificationTypeSound |
                                                              UIUserNotificationTypeAlert)
                                            categories:nil];
    [application registerUserNotificationSettings:settings];
    
    NSDictionary *remoteNotificationUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    NSLog(@"远程推动内容=%@",remoteNotificationUserInfo);
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = NO;
    manager.toolbarDoneBarButtonItemText = @"完成";
//    manager.toolbarTintColor = GrayColor;
    
    return YES;
}

#pragma mark -- 登录融云服务器
- (void)initRCIMtoken:(NSString *)token {
    
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        
        [[RCIM sharedRCIM] setEnableTypingStatus:YES];
        [[RCIM sharedRCIM] setEnableMessageMentioned:YES];
        [[RCIM sharedRCIM] setGlobalMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
        
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        
    } error:^(RCConnectErrorCode status) {
        [SVProgressHUD showMessage:@"初始化消息失败，重新启动"];
    } tokenIncorrect:^{
        [AVUser logOut];
        [SVProgressHUD showMessage:@"用户过期，需重新登录"];
    }];
}

#pragma mark -- 融云会话列表
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
    NSLog(@"用户id=%@",userId);
    
        AVUser *bbb = [AVQuery getUserObjectWithId:userId];
    
        RCUserInfo *use = [[RCUserInfo alloc] init];
        use.name = avoidNull(bbb.username);
        use.portraitUri = bbb[@"iconHead"];
        completion(use);
}

/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
    (UIUserNotificationSettings *)notificationSettings {
        // register to receive notifications
        [application registerForRemoteNotifications];
}
/**
 * 推送处理3
 */
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}
/**
 * 推送的内容
 */
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // userInfo为远程推送的内容
    NSLog(@"推送内容=%@",userInfo);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

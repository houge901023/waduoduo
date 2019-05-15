//
//  AppDelegate.h
//  waduoduo
//
//  Created by 名侯 on 2017/4/20.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic ,copy) NSString *RCIMtoken;

@property (nonatomic ,assign) BOOL newV; // 是否有新版本

@property (nonatomic ,assign) NSInteger refreshNum; //1 表示收藏  2.用户

@property (nonatomic ,assign) BOOL noPower; // 是否没权利

- (AFHTTPSessionManager *)sharedHTTPSession;
- (AFURLSessionManager *)sharedURLSession;

@end


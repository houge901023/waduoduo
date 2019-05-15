//
//  Network.h
//  XHLaunchAdExample
//
//  Created by zhuxiaohui on 2016/6/28.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHLaunchAd
//  数据请求类

#import <Foundation/Foundation.h>

typedef void(^NetworkSucess) (NSDictionary * response);
typedef void(^NetworkFailure) (NSError *error);

@interface Network : NSObject

/**
 *  此处用于模拟广告数据请求,实际项目中请做真实请求
 */
+(void)getLaunchAdImageDataSuccess:(NetworkSucess)success failure:(NetworkFailure)failure;
+(void)getLaunchAdVideoDataSuccess:(NetworkSucess)success failure:(NetworkFailure)failure;

/**
 POST请求
 
 @param url 接口
 @param parameters 参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)postXML:(NSString *)url parameters:(id)parameters success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/**
 GET请求
 
 @param url 接口
 @param parameters 参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)get:(NSString *)url parameters:(id)parameters success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;


/**
 GET请求(全拼)
 
 @param url 接口
 @param parameters 参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)getAll:(NSString *)url parameters:(id)parameters success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

@end

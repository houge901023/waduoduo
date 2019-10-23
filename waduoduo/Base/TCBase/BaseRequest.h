//
//  BaseRequest.h
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/11.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseRequest : NSObject

/**
 POST请求

 @param url 接口
 @param parameters 参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)post:(NSString *)url parameters:(id)parameters success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

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

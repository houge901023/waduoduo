//
//  Network.m
//  XHLaunchAdExample
//
//  Created by zhuxiaohui on 2016/6/28.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHLaunchAd
//  数据请求类
#import "Network.h"
#import <AFNetworking.h>
#import <XMLReader.h>

@implementation Network

/**
 *  此处模拟广告数据请求,实际项目中请做真实请求
 */
+(void)getLaunchAdImageDataSuccess:(NetworkSucess)success failure:(NetworkFailure)failure;
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LaunchImageAd" ofType:@"json"]];
        NSDictionary *json =  [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
        if(success) success(json);

    });
}
/**
 *  此处模拟广告数据请求,实际项目中请做真实请求
 */
+(void)getLaunchAdVideoDataSuccess:(NetworkSucess)success failure:(NetworkFailure)failure;
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LaunchVideoAd" ofType:@"json"]];
        NSDictionary *json =  [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
        if(success) success(json);
        
    });
}

+ (void)postXML:(NSString *)url parameters:(id)parameters success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [NSString stringWithFormat:@"%@%@",IP,url];
    
    AFHTTPSessionManager *mar = [APP_DELE sharedHTTPSession];
    mar.responseSerializer = [AFHTTPResponseSerializer serializer];
    mar.requestSerializer.timeoutInterval = 30.f;
    
    [mar POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [XMLReader dictionaryForXMLData:responseObject error:nil];
        
        if (success) {
            NSLog(@"成功返回=%@",dic);
            success(dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)get:(NSString *)url parameters:(id)parameters success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [NSString stringWithFormat:@"%@%@",IP,url];
    
    AFHTTPSessionManager *mar = [APP_DELE sharedHTTPSession];
    mar.responseSerializer = [AFHTTPResponseSerializer serializer];
    mar.requestSerializer.timeoutInterval = 10.f;
    
    [mar GET:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if (success) {
            NSLog(@"成功返回=%@",dic);
            success(dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getAll:(NSString *)url parameters:(id)parameters success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *mar = [APP_DELE sharedHTTPSession];
    mar.responseSerializer = [AFHTTPResponseSerializer serializer];
    mar.requestSerializer.timeoutInterval = 10.f;
    
    [mar GET:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if (success) {
            NSLog(@"成功返回=%@",dic);
            success(dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end

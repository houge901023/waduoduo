//
//  BaseRequest.m
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/11.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import "BaseRequest.h"


@implementation BaseRequest

+ (void)post:(NSString *)url parameters:(id)parameters success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [NSString stringWithFormat:@"%@%@",IP,url];
    
    AFHTTPSessionManager *mar = [APP_DELE sharedHTTPSession];
    mar.responseSerializer = [AFHTTPResponseSerializer serializer];
    mar.requestSerializer.timeoutInterval = 30.f;
    
    [mar POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
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

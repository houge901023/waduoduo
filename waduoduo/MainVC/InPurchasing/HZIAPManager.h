//
//  HZIAPManager.h
//  ZQjieshuo
//
//  Created by Apple  on 2019/4/1.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,IAPResultType) {
    IAPResultSuccess = 0,       // 购买成功
    IAPResultFailed = 1,        // 购买失败
    IAPResultCancle = 2,        // 取消购买
    IAPResultVerFailed = 3,     // 订单校验失败
    IAPResultVerSuccess = 4,    // 订单校验成功
    IAPResultNotArrow = 5,      // 不允许内购
    IAPResultIDError = 6,       // 项目ID错误
};

typedef void(^IAPCompletionHandle)(IAPResultType type,NSData *data);

@interface HZIAPManager : NSObject

+ (instancetype)shareIAPManager;

/**
 开启内购
 
 @param productID 内购项目的产品ID
 @param handle 内购的结果回调
 */
- (void)startIAPWithProductID:(NSString *)productID  completeHandle: (IAPCompletionHandle)handle;

@end

NS_ASSUME_NONNULL_END

//
//  secondModel.h
//  waduoduo
//
//  Created by Apple  on 2019/4/16.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface secondModel : NSObject

@property (nonatomic ,strong) NSString *BrandName; // 品牌
@property (nonatomic ,strong) NSString *CName2; // 类型（挖掘机）
@property (nonatomic ,strong) NSString *Spec; // 设备型号
@property (nonatomic ,strong) NSString *sHour; // 工作时间
@property (nonatomic ,strong) NSString *Years; // 购买年份
@property (nonatomic ,strong) NSString *liulanCount; // 浏览量
@property (nonatomic ,strong) NSString *IfHot; // 是否热门
@property (nonatomic ,strong) NSString *StkTitle; // 标题
@property (nonatomic ,strong) NSString *LastDate; // 时间
@property (nonatomic ,strong) NSString *PhotoPath; // 图片
@property (nonatomic ,strong) NSString *WPrice; // 价格

@property (nonatomic ,strong) NSString *Linkman; // 联系人
@property (nonatomic ,strong) NSString *Mobile; // 手机号
@property (nonatomic ,strong) NSString *province; // 省份
@property (nonatomic ,strong) NSString *area; // 地址
@property (nonatomic ,strong) NSString *SAddress; // 具体地址

@end

NS_ASSUME_NONNULL_END

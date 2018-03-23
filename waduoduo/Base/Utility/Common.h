//
//  Common.h
//  SanRentou
//
//  Created by 李洪旭 on 16/1/16.
//  Copyright © 2016年 安迪时代网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+Hex.h"

@interface Common : NSObject

/**
 *  没有代理的提示框
 */
+ (void)addAlertOneButton:(NSString *)string;

/**
 *  发送验证码自动倒计时
 */
+ (void)verificationCode:(void(^)())blockYes blockNo:(void(^)(id time))blockNo;

/**
 网络请求图片
 */
//+ (NSURL *)imageURL:(NSString *)string;

/**
 存储、修改cookie
 */
+ (void)saveLoginSession;

/**
 启动app时更新cookie
 */
+ (void)updateSession;

/**
 删除cookie
 */
+ (void)removeLoginSession;
/**
 图片压缩
 */
//+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage;
+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize;

/**
 计算当前时间与特定时间之间的天数
 */
+ (NSString *)timeIntervalSince1970:(NSString *)dateline;

/**
 计算当前时间与特定时间之间的天数
 */
+ (NSString *)timeCountdown:(NSTimeInterval)timer;

/**
 将格式化的时间转换成时间戳
 */
+ (int)changeTimeToTimeSp:(NSString *)timeStr;

/**
 将格式化的时间转换成NSTimeInterval
 */
+ (NSTimeInterval)dateConverter:(NSString *)string format:(NSString *)formatString;

/**
 将时间戳转换为正常时间，年月日时分秒
 */
+ (NSString *)timeString:(NSString *)string;
/**
 四舍五入显示百分比
 */
+ (NSString *)percentageRounded:(CGFloat)decimal;

/**
 判断当前设备型号
 */
+ (NSString*)deviceString;

/**
 计算字符串的高度
 */
+ (CGFloat)stringHeight:(NSString *)string font:(NSInteger)font;

/**
 取出相对应的城市名编码
 */
//+ (NSString *)takeOutTheCode:(NSString *)name;

/**
 验证手机号码是否正确
 */
+ (BOOL) validateMobile:(NSString *)mobile;

/**
 渲染label字体颜色
 */
+ (NSMutableAttributedString *)Renderlabel:(NSString *)string start:(NSRange)colorRange start:(NSRange)fontRange font:(CGFloat)font color:(UIColor *)color;

/**
 删除数组中重复的元素
 **/
+ (NSMutableArray *)arrayWithMemberIsOnly:(NSArray *)array;

/**
 封装label
 **/
+ (UILabel *)initLabel:(NSString *)string addSubView:(UIView *)view;

/**
 根据字符串计算文本的大小
 **/
+ (CGSize)stringwidth:(NSString *)string font:(NSInteger)font;


+ (NSMutableArray *)ModelTransformationWithResponseObject:(id)responseObject modelClass:(Class)modelClass;
+ (UIImage*) createImageWithColor: (UIColor*) color;
@end

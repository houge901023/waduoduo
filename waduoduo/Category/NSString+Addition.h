//
//  NSString+Addition.h
//  EasyLife
//
//  Created by LiangYe on 16/9/1.
//  Copyright © 2016年 LiangYe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSString (Addition) 


- (NSString *)contractionsImageViewUrl;

/**
 *  无空格和换行的字符串 
 */
- (NSString *)noWhiteSpaceString;

/** 计算字体大小和换行需要最大换行距离*/
- (CGSize)sizeWithText:(UIFont *)font maxW:(CGFloat)maxW;

/** 计算字体大小和换行*/
- (CGSize)sizeWithText:(UIFont *)font;

/**
 *  计算当前文件\文件夹的内容大小
 */
- (NSInteger)fileSize;
/**
 *  判断手机号
 */
- (BOOL)isPhoneNumber;
/**
 *  判断手机号
 */
- (BOOL)isValidateMobile:(NSString *)mobileNum;
/**
 *  判断邮箱
 */
-(BOOL)isEmailWithString:(NSString *)str;
/**
 *  判断国际手机号
 */
-(BOOL)isGloabelNumberWithString:(NSString *)str;

/**
 返回处理过的字符串，只保留小数点后两位，结尾0省略
 */
- (instancetype)dealedPriceString;
/**
 * 判断中文和英文字符串的长度
 */
- (int)convertToInt:(NSString*)strtemp;
/**
 *  字符串md5加密
 */
- (NSString *) stringWithMD5;
/**
 *  字符串sha1加密
 */
- (NSString *) stringWithSha1;


@end
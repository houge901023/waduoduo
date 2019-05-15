//
//  EasyEmptyView.h
//  EasyShowViewDemo
//
//  Created by nf on 2018/1/16.
//  Copyright © 2018年 chenliangloveyou. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EasyEmptyPart.h"
#import "EasyEmptyConfig.h"
#import "EasyEmptyTypes.h"

@interface EasyEmptyView : UIScrollView

+ (EasyEmptyView *)showEmptyInView:(UIView *)superview
                              part:(EasyEmptyPart *(^)(void))part ;

+ (EasyEmptyView *)showEmptyInView:(UIView *)superview
                              part:(EasyEmptyPart *(^)(void))part
                            config:(EasyEmptyConfig *(^)(void))config ;

+ (EasyEmptyView *)showEmptyInView:(UIView *)superview
                              part:(EasyEmptyPart *(^)(void))part
                            config:(EasyEmptyConfig *(^)(void))config
                          callback:(emptyViewCallback)callback ;


+ (void)hiddenEmptyInView:(UIView *)superView ;
+ (void)hiddenEmptyView:(EasyEmptyView *)emptyView ;


/**
 请求数据为空

 @param superview 显示的父视图
 @param callback 点击回调
 @return 视图
 */
+ (EasyEmptyView *)showEmptyInView:(UIView *)superview callback:(emptyViewCallback)callback;

/**
 请求出错

 @param superview 显示的父视图
 @param callback 点击回调
 @return 视图
 */
+ (EasyEmptyView *)showErrorInView:(UIView *)superview callback:(emptyViewCallback)callback;

@end

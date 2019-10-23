//
//  BaseVC.h
//  jinqiaoliang
//
//  Created by 名侯 on 2017/3/20.
//  Copyright © 2017年 深圳前海金桥梁互联网金融服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasyEmptyView.h"

@interface BaseVC : UIViewController

@property (nonatomic, weak) UIView *navBarView;
/** 加载视图蒙版*/
@property (nonatomic ,strong) UIView *maskView;

//自定义返回按钮
- (void)configureLeft:(NSString *)string;
//自定义返回按钮
- (void)configureLeftImage:(NSString *)imgName;
//自定义导航栏右边按钮--文字
- (void)configureRight:(NSString *)string;
//自定义导航栏右边按钮--图片
- (void)configureRightImage:(NSString *)imgName;
- (void)configureRightImage1:(NSString *)imgName setImage2:(NSString *)imgName2;
//导航栏右边点击事件
- (void)rightNavAction;
//返回的点击事件
- (void)backNavAction;
- (void)btnAction:(UIButton *)btn;

//设置边框
-(void)setBorder:(UIView *)view size:(float)size;
//设置边框+颜色
-(void)setBorder:(UIView *)view size:(float)size withColor:(UIColor *)color;
//设置成圆形
-(void) setYuan:(UIView *)view size:(double)size;
//阴影
- (void)setshadow:(UIView *)view;
//阴影自定义
- (void)setshadow:(UIView *)view scope:(CGFloat)width transparent:(CGFloat)alpha direction:(CGSize)size;
//生产1像素的线
- (void)PixeOrigin:(CGPoint)origin length:(CGFloat)length isVertical:(BOOL)isVertical color:(UIColor *)color add:(UIView *)supview;
//生产水平线
- (void)PixeH:(CGPoint)origin lenght:(CGFloat)length add:(UIView *)supview;
- (void)PixeH2:(CGPoint)origin lenght:(CGFloat)length add:(UIView *)supview;
//生产垂直线
- (void)PixeV:(CGPoint)origin lenght:(CGFloat)length add:(UIView *)supview;
//存值
- (void)setUserifon:(id)value andKey:(NSString *)key;

#pragma mark -- 创建主按钮
- (UIButton *)setbutton:(NSString *)str setY:(CGFloat)Y add:(UIView *)view;
- (void)mainAction;

- (NSMutableAttributedString *)setAttri:(NSString *)str;

#pragma mark -- 空数据加载框
- (void)showLoding:(CGRect)frame setText:(NSString *)text;
- (void)showLodingImage;
- (void)hidenLoding;

@end

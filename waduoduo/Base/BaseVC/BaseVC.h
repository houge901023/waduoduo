//
//  BaseVC.h
//  jinqiaoliang
//
//  Created by 名侯 on 2017/3/20.
//  Copyright © 2017年 深圳前海金桥梁互联网金融服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseVC : UIViewController

@property (nonatomic, weak) UIView *navBarView;

//自定义返回按钮
- (void)configureLeft:(NSString *)string;
//自定义导航栏右边按钮--文字
- (void)configureRight:(NSString *)string;
//自定义导航栏右边按钮--图片
- (void)configureRightImage:(NSString *)imgName;
//导航栏右边点击事件
- (void)rightNavAction;
//返回的点击事件
- (void)backNavAction;

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

#pragma mark -- AFN网络框架
- (void)post:(NSString *)URLString parameters:(NSMutableDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;

#pragma mark -- 创建主按钮
- (UIButton *)setbutton:(NSString *)str setY:(CGFloat)Y add:(UIView *)view;
- (void)mainAction;

- (NSMutableAttributedString *)setAttri:(NSString *)str;

@end

//
//  BaseVController.h
//  BASE1
//
//  Created by 鸿朔 on 2017/9/6.
//  Copyright © 2017年 鸿朔. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, ErrorImgType)
{
    Nodata = 0,
    Nonetwork,
    Norecommend,
    Nosearch
};// NS_ENUM多用于一般枚举,而NS_OPTIONS则多用于带有移位运算的枚举

@interface BaseVController : UIViewController

@property (nonatomic ,weak) UIView *NavBar;//导航栏
@property (nonatomic ,weak) UILabel *titleLB;//标题
@property (nonatomic ,weak) UIButton *NavLeft;//导航栏左边Btn
@property (nonatomic ,weak) UIButton *NavRight;//导航栏右边Btn
@property (nonatomic ,strong) MJRefreshNormalHeader *MJHeader;//下拉刷新
@property (nonatomic ,strong) MJRefreshBackNormalFooter *MJFooter;//上拉加载

- (void)backAction;
- (void)rightAction;
- (void)loadNewData;
- (void)loadMoreData;
- (UIImage *)getImage:(UITableView *)cell;

#pragma mark -- 其他工具方法定义
// 生产1像素的线
- (void)PixeOrigin:(CGPoint)origin length:(CGFloat)length isVertical:(BOOL)isVertical color:(UIColor *)color add:(UIView *)supview;
// 生产水平线
- (void)PixeH:(CGPoint)origin lenght:(CGFloat)length add:(UIView *)supview;
// 生产垂直线
- (void)PixeV:(CGPoint)origin lenght:(CGFloat)length add:(UIView *)supview;
// 存值
- (void)setUserifon:(id)value andKey:(NSString *)key;
// 设置边框
-(void)setBorder:(UIView *)view size:(float)size;
// 设置边框+颜色
-(void)setBorder:(UIView *)view size:(float)size withColor:(UIColor *)color;
// 设置成圆形
-(void) setYuan:(UIView *)view size:(double)size;
// 阴影
- (void)setshadow:(UIView *)view;
// 阴影自定义
- (void)setshadow:(UIView *)view scope:(CGFloat)width transparent:(CGFloat)alpha direction:(CGSize)size;
// 界面异常图片
- (UIImageView *)errorView:(ErrorImgType)type addView:(UIView *)bView;



@end

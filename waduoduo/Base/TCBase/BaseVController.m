//
//  BaseVController.m
//  BASE1
//
//  Created by 鸿朔 on 2017/9/6.
//  Copyright © 2017年 鸿朔. All rights reserved.
//

#import "BaseVController.h"

@interface BaseVController ()

@end

@implementation BaseVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置自定义导航栏
    [self setNavigationBar];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 布局自定义导航栏
- (void)setNavigationBar {
    
    UIView *Nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, JLNavH)];
    Nav.backgroundColor = COLOR_MAIN;
    [self.view addSubview:Nav];
    [self PixeH:CGPointMake(0, JLNavH-1) lenght:SCREEN_WIDTH add:Nav];
    self.NavBar = Nav;
   
    // 返回Item
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, JLNavY(20), 42, 42)];
    [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [Nav addSubview:leftBtn];
    self.NavLeft = leftBtn;
    
    // 中间文字
    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(50, JLNavY(20), SCREEN_WIDTH-100, 44)];
    titleLB.textColor = [UIColor whiteColor];
    titleLB.font = [UIFont boldSystemFontOfSize:18];
    titleLB.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLB];
    self.titleLB = titleLB;
    
    // 右边Item
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-49, JLNavY(20), 44, 44)];
    [rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [Nav addSubview:rightBtn];
    self.NavRight = rightBtn;
}
- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    self.titleLB.text = title;
}
// 导航栏左边按钮事件
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}
// 导航栏右边按钮事件
- (void)rightAction {
    
}
// 创建下拉刷新
- (MJRefreshNormalHeader *)MJHeader {
    if (_MJHeader == nil) {
        _MJHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    }
    return _MJHeader;
}
- (void)loadNewData {
    
}
// 创建上拉加载
- (MJRefreshBackNormalFooter *)MJFooter {
    if (_MJFooter == nil) {
        _MJFooter = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
    }
    return _MJFooter;
}
- (void)loadMoreData {
    
}
#pragma mark -- 其他工具方法定义
// 生产1像素的线
- (void)PixeOrigin:(CGPoint)origin length:(CGFloat)length isVertical:(BOOL)isVertical color:(UIColor *)color add:(UIView *)supview {
    CGFloat width = 1/[UIScreen mainScreen].scale;
    CGFloat offset = ((1-[UIScreen mainScreen].scale)/2);
    
    UIView *view;
    if (isVertical) {   // 垂直的线
        view = [[UIView alloc] initWithFrame:CGRectMake(ceil(origin.x) + offset, origin.y, width, length)];
    }
    else {  // 水平的线
        view = [[UIView alloc] initWithFrame:CGRectMake(origin.x, ceil(origin.y)+(1-width), length, width)];
    }
    view.backgroundColor = color;
    [supview addSubview:view];
}
// 默认水平线
- (void)PixeH:(CGPoint)origin lenght:(CGFloat)length add:(UIView *)supview {
    
    CGFloat width = 1/[UIScreen mainScreen].scale;
    CGFloat offset;
    if (origin.y==0) {
        offset = 0;
    }else {
        offset = 1-width;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(origin.x, ceil(origin.y)+offset, length, width)];
    view.backgroundColor = UIColorFromRGB(0xcfcfcf);
    [supview addSubview:view];
}
// 默认垂直线
- (void)PixeV:(CGPoint)origin lenght:(CGFloat)length add:(UIView *)supview {
    CGFloat width = 1/[UIScreen mainScreen].scale;
    CGFloat offset = ((1-[UIScreen mainScreen].scale)/2);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(ceil(origin.x) + offset, origin.y, width, length)];
    view.backgroundColor = UIColorFromRGB(0xcfcfcf);
    [supview addSubview:view];
}
// 收键盘
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
// 存值
- (void)setUserifon:(id)value andKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}
// 设置成圆形
-(void)setYuan:(UIView *)view size:(double)size{
    view.layer.masksToBounds=YES;
    view.layer.cornerRadius=size;
}
// 设置边框
-(void)setBorder:(UIView *)view size:(float)size{
    CGFloat width = 1/[UIScreen mainScreen].scale;
    view.layer.borderColor=UIColorFromRGB(0xcfcfcf).CGColor;
    view.layer.borderWidth=size*width;
}
// 设置边框+颜色
-(void)setBorder:(UIView *)view size:(float)size withColor:(UIColor *)color{
    CGFloat width = 1/[UIScreen mainScreen].scale;
    view.layer.borderColor=color.CGColor;
    view.layer.borderWidth=width*size;
}
// 阴影
- (void)setshadow:(UIView *)view {
    //        CALayer *layer = [view layer];
    //        layer.borderColor = [[UIColor whiteColor] CGColor];
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(2, 2);
    view.layer.shadowOpacity = 0.3;
    view.layer.shadowRadius = 1;
}
// 阴影自定义
- (void)setshadow:(UIView *)view scope:(CGFloat)width transparent:(CGFloat)alpha direction:(CGSize)size {
    
    view.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    view.layer.shadowOffset = CGSizeMake(size.width, size.height);//阴影方向
    view.layer.shadowOpacity = alpha;//阴影透明度
    view.layer.shadowRadius = width;//阴影范围
}
// 界面异常图片
- (UIImageView *)errorView:(ErrorImgType)type addView:(UIView *)bView {
    
    UIImageView *errorView = [[UIImageView alloc] init];
    
    switch (type) {
        case Nodata:
            errorView.image = [UIImage imageNamed:@"nodata"];
            errorView.size = CGSizeMake(150, 150);
            break;
        case Nonetwork:
            errorView.image = [UIImage imageNamed:@"WiFi"];
            errorView.size = CGSizeMake(SPwidth6(165), SPwidth6(165));
            break;
        case Nosearch:
            errorView.image = [UIImage imageNamed:@"noSearchResult"];
            errorView.size = CGSizeMake(SPwidth6(147), SPwidth6(135));
            break;
        case Norecommend:
            errorView.image = [UIImage imageNamed:@"NoRecommend"];
            errorView.size = CGSizeMake(SPwidth6(150), SPwidth6(150));
            break;
        default:
            break;
    }
    
    errorView.center = bView.center;
    [bView addSubview:errorView];
    
    return errorView;
}

- (UIImage *)getImage:(UITableView *)cell

{
    
    UIImage* viewImage = nil;
    UITableView *scrollView = cell;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, scrollView.opaque, 0.0);
    {
        
        CGPoint savedContentOffset = scrollView.contentOffset;
        
        CGRect savedFrame = scrollView.frame;
        
        
        
        scrollView.contentOffset = CGPointZero;
        
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        
        viewImage = UIGraphicsGetImageFromCurrentImageContext();
        
        
        
        scrollView.contentOffset = savedContentOffset;
        
        scrollView.frame = savedFrame;
        
    }
    
    UIGraphicsEndImageContext();
    
    return viewImage;
    
}
@end

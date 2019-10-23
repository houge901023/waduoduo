//
//  BaseVC.m
//  jinqiaoliang
//
//  Created by 名侯 on 2017/3/20.
//  Copyright © 2017年 深圳前海金桥梁互联网金融服务有限公司. All rights reserved.
//

#import "BaseVC.h"
#import <AFNetworking.h>
#import <UIImage+GIF.h>

@interface BaseVC ()

@property (nonatomic ,strong)EasyLoadingView *Loding;

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1.00f];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage coloreImage:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self navBarView];
    
    self.view.size = [UIScreen mainScreen].bounds.size;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //去除导航栏下方的横线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (UIView *)navBarView {
    if (!_navBarView) {
        UIView *navBarView = [[UIView alloc] init];
        navBarView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, JLNavH);
        [self.view addSubview:navBarView];
        _navBarView = navBarView;
        _navBarView.backgroundColor = [UIColor whiteColor];
        [self PixeH:CGPointMake(0, JLNavH-1) lenght:SCREEN_WIDTH add:_navBarView];
    }
    return _navBarView;
}

//自定义标题
- (void)configureTitleView
{
    UILabel *headlinelabel = [UILabel new];
    headlinelabel.font = [UIFont fontWithName:@"Avenir-Light" size:20];
    headlinelabel.textAlignment = NSTextAlignmentCenter;
    headlinelabel.textColor = [UIColor blackColor];
    
    headlinelabel.text = self.title;
    [headlinelabel sizeToFit];
    
    [self.navigationItem setTitleView:headlinelabel];
}
//自定义导航栏右边按钮--文字
- (void)configureRight:(NSString *)string {
    
    UILabel *headlinelabel = [UILabel new];
    headlinelabel.font = [UIFont systemFontOfSize:15];
    headlinelabel.textAlignment = NSTextAlignmentCenter;
    headlinelabel.textColor = color(84, 84, 84, 1);
    headlinelabel.userInteractionEnabled = YES;
    headlinelabel.text = string;
    [headlinelabel sizeToFit];
    //设置手势
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightNavAction)];
    [headlinelabel addGestureRecognizer:rightTap];
    UIBarButtonItem *rightbar=[[UIBarButtonItem alloc] initWithCustomView:headlinelabel];
    self.navigationItem.rightBarButtonItem = rightbar;
}
//自定义返回按钮
- (void)configureLeft:(NSString *)string {
    
    UIButton *sender = [UIButton new];
//    [sender setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [sender setTitleColor:colorValue(0x333333, 1) forState:UIControlStateNormal];
    [sender setTitle:string forState:UIControlStateNormal];
    sender.titleLabel.font = kFONT(15);
    
    [sender setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    [sender setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    
    [sender sizeToFit];
    [sender addTarget:self action:@selector(backNavAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftbar=[[UIBarButtonItem alloc] initWithCustomView:sender];
    self.navigationItem.leftBarButtonItem = leftbar;
}
//自定义返回按钮
- (void)configureLeftImage:(NSString *)imgName {
    
    UIButton *sender = [UIButton new];
    [sender setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];

    
    [sender sizeToFit];
    [sender addTarget:self action:@selector(backNavAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftbar=[[UIBarButtonItem alloc] initWithCustomView:sender];
    self.navigationItem.leftBarButtonItem = leftbar;
}
//自定义导航栏右边按钮--图片
- (void)configureRightImage:(NSString *)imgName {
    
    UIButton *NavRightBT = [UIButton new];
    [NavRightBT setImage:kIMG(imgName) forState:UIControlStateNormal];
    [NavRightBT addTarget:self action:@selector(rightNavAction) forControlEvents:UIControlEventTouchUpInside];
    [NavRightBT sizeToFit];
    
    UIBarButtonItem *rightbar=[[UIBarButtonItem alloc] initWithCustomView:NavRightBT];
    self.navigationItem.rightBarButtonItem = rightbar;
}

- (void)configureRightImage1:(NSString *)imgName setImage2:(NSString *)imgName2 {
    
    UIView *batView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 40)];
    batView.backgroundColor = [UIColor clearColor];
    
    for (int i=0; i<2; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*50, 0, 40, 40)];
        [btn setImage:[UIImage imageNamed:@[imgName,imgName2][i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 7000+i;
        [batView addSubview:btn];
    }
    
    UIBarButtonItem *rightbar=[[UIBarButtonItem alloc] initWithCustomView:batView];
    self.navigationItem.rightBarButtonItem = rightbar;
    
}

- (void)rightNavAction {
    NSLog(@"点击了导航栏右边按钮");
}

- (void)backNavAction {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)btnAction:(UIButton *)btn {
    
}

//设置边框
-(void)setBorder:(UIView *)view size:(float)size{
    CGFloat width = 1/[UIScreen mainScreen].scale;
    view.layer.borderColor=BorderColor.CGColor;
    view.layer.borderWidth=size*width;
}
//设置边框+颜色
-(void)setBorder:(UIView *)view size:(float)size withColor:(UIColor *)color{
    CGFloat width = 1/[UIScreen mainScreen].scale;
    view.layer.borderColor=color.CGColor;
    view.layer.borderWidth=width*size;
}
//设置成圆形
-(void)setYuan:(UIView *)view size:(double)size{
    view.layer.masksToBounds=YES;
    view.layer.cornerRadius=size;
}
//阴影
- (void)setshadow:(UIView *)view {
    //    CALayer *layer = [view layer];
    //    layer.borderColor = [[UIColor whiteColor] CGColor];
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(2, 2);
    view.layer.shadowOpacity = 0.3;
    view.layer.shadowRadius = 1;
}
//阴影自定义
- (void)setshadow:(UIView *)view scope:(CGFloat)width transparent:(CGFloat)alpha direction:(CGSize)size {
    
    view.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    view.layer.shadowOffset = CGSizeMake(size.width, size.height);//阴影方向
    view.layer.shadowOpacity = alpha;//阴影透明度
    view.layer.shadowRadius = width;//阴影范围
}
//生产1像素的线
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
//默认水平线
- (void)PixeH:(CGPoint)origin lenght:(CGFloat)length add:(UIView *)supview {
    
    CGFloat width = 1/[UIScreen mainScreen].scale;
    CGFloat offset;
    if (origin.y==0) {
        offset = 0;
    }else {
        offset = 1-width;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(origin.x, ceil(origin.y)+offset, length, width)];
    view.backgroundColor = BorderColor;
    [supview addSubview:view];
}
//默认水平线
- (void)PixeH2:(CGPoint)origin lenght:(CGFloat)length add:(UIView *)supview {
    
    CGFloat width = 1/[UIScreen mainScreen].scale;
    CGFloat offset;
    if (origin.y==0) {
        offset = 0;
    }else {
        offset = 1-width;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(origin.x, ceil(origin.y)+offset, length, width)];
    view.backgroundColor = color(229, 229, 229, 1);
    [supview addSubview:view];
}
//默认垂直线
- (void)PixeV:(CGPoint)origin lenght:(CGFloat)length add:(UIView *)supview {
    CGFloat width = 1/[UIScreen mainScreen].scale;
    CGFloat offset = ((1-[UIScreen mainScreen].scale)/2);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(ceil(origin.x) + offset, origin.y, width, length)];
    view.backgroundColor = BorderColor;
    [supview addSubview:view];
}
//收键盘
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
//存值
- (void)setUserifon:(id)value andKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

- (NSMutableAttributedString *)setAttri:(NSString *)str {
    
    NSMutableAttributedString *cons = [[NSMutableAttributedString alloc] initWithString:str];
    [cons addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(str.length-1, 1)];
    
    return cons;
}

#pragma mark -- 创建主按钮
- (UIButton *)setbutton:(NSString *)str setY:(CGFloat)Y add:(UIView *)view {
    
    UIButton *sender = [[UIButton alloc] initWithFrame:CGRectMake(15, Y, SCREEN_WIDTH-30, kWidth(45))];
    sender.backgroundColor = mainBlue;
    [sender setTitle:str forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sender.titleLabel.font = kFONT(18);
    [sender addTarget:self action:@selector(mainAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sender];
    [self setYuan:sender size:kWidth(5)];
    return sender;
}

- (void)mainAction {
    
}

// 空界面加载框
- (UIView *)maskView {
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor whiteColor];
    }
    return _maskView;
}
- (void)showLoding:(CGRect)frame setText:(NSString *)text {
    
    self.maskView.frame = frame;
    self.maskView.hidden = NO;
    self.maskView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.maskView];
    
    EasyLoadingView *Loding =
    [EasyLoadingView showLoadingText:text config:^EasyLoadingConfig *{
        EasyLoadingConfig *config = [EasyLoadingConfig shared].setLoadingType(LoadingShowTypePlayImagesLeft).setSuperReceiveEvent(NO).setBgColor([UIColor whiteColor]);
        config.animationType = TextAnimationTypeNone;
        return config;
    }];
    [self.maskView addSubview:Loding];
    Loding.centerY = self.maskView.height/2;
}
- (void)showLodingImage {
    
    self.maskView.hidden = NO;
    self.maskView.backgroundColor = [UIColor clearColor];
    EasyLoadingView *Loding =
    [EasyLoadingView showLoadingText:@"" config:^EasyLoadingConfig *{
        EasyLoadingConfig *config = [EasyLoadingConfig shared].setLoadingType(LoadingShowTypePlayImagesLeft).setSuperReceiveEvent(YES);
        config.animationType = TextAnimationTypeNone;
        return config;
    }];
    [self.maskView addSubview:Loding];
    Loding.centerY = self.maskView.height/2;
}
- (void)hidenLoding {
    self.maskView.hidden = YES;
    [EasyLoadingView hidenLoingInView:self.maskView];
}



@end

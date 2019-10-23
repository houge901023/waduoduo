//
//  MainTabBarController.m
//  TradeUnion
//
//  Created by Kaka on 2017/2/14.
//  Copyright © 2017年 bzunion. All rights reserved.
//

#import "MainTabBarController.h"
#import "MainTabBar.h"
#import "MainNavigationController.h"
#import "OlddriversVC.h"
#import "PersonalVC.h"
#import "RKNotificationHub.h"
#import "ZFWeiboButton.h"
#import "ZFIssueWeiboView.h"
#import "AdddemandVC.h"
#import "AddSupplyVC.h"
#import "PartsVC.h"
#import "DemandVC.h"
#import "SupplyVC.h"
#import "SecondHandVC.h"
#import "AddProductVC.h"

//image ratio 带字默认0.6
#define TabBarButtonH (iPhoneX ? 83 : 49)

@interface MainTabBarController ()<MainTabBarDelegate,ZFIssueWeiboViewDelegate>

@property(nonatomic, weak)MainTabBar *mainTabBar;
@property(nonatomic, strong) RKNotificationHub *Rednum;

@end

@implementation MainTabBarController


/**
 *  单利
 *
 *  @return 唯一性
 */
+ (instancetype)shareInstance{
    static MainTabBarController * instance = nil;
    static dispatch_once_t tocken ;
    
    dispatch_once(&tocken, ^{
        
        instance = [[MainTabBarController alloc] init];
    });
    
    return instance;
}

- (RKNotificationHub *)Rednum {
    if (_Rednum==nil) {
        _Rednum = [[RKNotificationHub alloc] init];
    }
    return _Rednum;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self SetupMainTabBar];
    [self SetupAllControllers];

}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [child removeFromSuperview];
        }
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
    [self setup];
}

- (void)SetupMainTabBar{
    
    MainTabBar *mainTabBar = [[MainTabBar alloc] init];
    mainTabBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, TabBarButtonH);
    mainTabBar.delegate = self;
    self.tabBar.backgroundColor = [UIColor whiteColor];
    [self.tabBar addSubview:mainTabBar];
    _mainTabBar = mainTabBar;
}

- (void)SetupAllControllers{
    
    
    NSArray *titles = @[@"供求", @"二手", @"", @"消息", @"我的"];
    NSArray *images = @[@"ntab_1", @"ntab_2", @"",@"ntab_3", @"ntab_4"];
    NSArray *selectedImages = @[@"ntab_1_ed", @"ntab_2_ed", @"", @"ntab_3_ed", @"ntab_4_ed"];
    
    SupplyVC *home = [[SupplyVC alloc] init];
    home.title = @"挖多多";
    home.Personal = NO;
    SecondHandVC *lend = [[SecondHandVC alloc] init];
    lend.title = @"优质二手设备";
    OlddriversVC *found = [[OlddriversVC alloc] init];
    PersonalVC *my = [[PersonalVC alloc] init];
    
    //    self.viewControllers=@[homePage,municipio,tools,mine];

    NSArray *viewControllers = @[home,lend,my,found,my];;
    
    for (int i = 0; i < viewControllers.count; i++) {
        UIViewController *childVc = viewControllers[i];
        [self SetupChildVc:childVc title:titles[i] image:images[i] selectedImage:selectedImages[i]];
    }
}

- (void)SetupChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName{
    
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:childVc];
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    childVc.tabBarItem.title = title;
    [self.mainTabBar addTabBarButtonWithTabBarItem:childVc.tabBarItem];
    [self addChildViewController:nav];
}

- (void)setup {
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/5*2, 0, SCREEN_WIDTH/5, 49)];
    [button setImage:[UIImage imageNamed:@"ntab_add"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addcontent) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:button];
}

- (void)addcontent {
    NSLog(@"点击了发布");
    ZFIssueWeiboView *view = [ZFIssueWeiboView initIssueWeiboView];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    view.delegate = self;
    [APP_DELE.window addSubview:view];
}

#pragma mark -- 分享代理
- (void)animationHasFinishedWithButton:(ZFWeiboButton *)button {
    if ([AVUser currentUser]==nil) {
        [EasyTextView showInfoText:@"不能发布，请先登录"];
        return;
    }
    if (APP_DELE.newV==NO) {
        [EasyTextView showInfoText:@"请更新版本"];
        return;
    }
    if (APP_DELE.noPower==YES) {
        return [EasyTextView showInfoText:@"你暂时无权限访问"];
    }
    if (button.tag==1000) {
        AdddemandVC *MVC = [[AdddemandVC alloc] init];
        MainNavigationController *NAV = [[MainNavigationController alloc] initWithRootViewController:MVC];
        [self presentViewController:NAV animated:YES completion:nil];
    }else if (button.tag==1001) {
        AddProductVC *MVC = [[AddProductVC alloc] init];
        MainNavigationController *NAV = [[MainNavigationController alloc] initWithRootViewController:MVC];
        [self presentViewController:NAV animated:YES completion:nil];
    }
}

#pragma mark --------------------mainTabBar delegate
- (void)tabBar:(MainTabBar *)tabBar didSelectedButtonFrom:(long)fromBtnTag to:(long)toBtnTag {
    
    self.selectedIndex = toBtnTag;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

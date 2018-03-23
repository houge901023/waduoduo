//
//  MainTabBar.m
//  TradeUnion
//
//  Created by Kaka on 2017/2/14.
//  Copyright © 2017年 bzunion. All rights reserved.
//

#import "MainTabBar.h"

#import "MainTabBar.h"
#import "MainTabBarButton.h"
#import "UIColor+HexColor.h"
#import "RKNotificationHub.h"

@interface MainTabBar ()

@property(nonatomic, strong)NSMutableArray *tabbarBtnArray;
@property(nonatomic, weak)MainTabBarButton *selectedButton;
@property(nonatomic, strong) RKNotificationHub *Rednum;

@end

@implementation MainTabBar
- (NSMutableArray *)tabbarBtnArray{
    if (!_tabbarBtnArray) {
        _tabbarBtnArray = [NSMutableArray array];
    }
    return  _tabbarBtnArray;
}
//- (RKNotificationHub *)Rednum {
//    if (_Rednum==nil) {
//        _Rednum = [[RKNotificationHub alloc] init];
//    }
//    return _Rednum;
//}
- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"fcfcfc"];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithHexString:@"f5f5f5"].CGColor;
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat btnY = 0;
    CGFloat btnW = self.frame.size.width/(self.subviews.count);
    CGFloat btnH = 49;
    
    for (int nIndex = 0; nIndex < self.tabbarBtnArray.count; nIndex++) {
        CGFloat btnX = btnW * nIndex;
        MainTabBarButton *tabBarBtn = self.tabbarBtnArray[nIndex];
        tabBarBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        tabBarBtn.tag = nIndex;
    }
}

- (void)addTabBarButtonWithTabBarItem:(UITabBarItem *)tabBarItem{
    MainTabBarButton *tabBarBtn = [[MainTabBarButton alloc] init];
    tabBarBtn.tabBarItem = tabBarItem;
    [tabBarBtn addTarget:self action:@selector(ClickTabBarButton:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:tabBarBtn];
    [self.tabbarBtnArray addObject:tabBarBtn];
    
    //default selected first one
    if (self.tabbarBtnArray.count == 1) {
        [self ClickTabBarButton:tabBarBtn];
    }else if (self.tabbarBtnArray.count==4) {
//        self.Rednum = [[RKNotificationHub alloc] initWithView:tabBarBtn];
//        [self.Rednum setCircleAtFrame:CGRectMake(SCREEN_WIDTH/8+2, 5, 16, 16)];
//        [self.Rednum incrementBy:100];
    }
}

- (void)ClickTabBarButton:(MainTabBarButton *)tabBarBtn{
    
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:self.selectedButton.tag to:tabBarBtn.tag];
    }
    
//    NSLog(@"看看=%ld",tabBarBtn.tag);
//    if (tabBarBtn.tag==3) {
//        [self.Rednum decrementBy:100];
//    }
    
    self.selectedButton.selected = NO;
    tabBarBtn.selected = YES;
    self.selectedButton = tabBarBtn;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

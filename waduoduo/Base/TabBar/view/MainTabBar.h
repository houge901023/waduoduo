//
//  MainTabBar.h
//  TradeUnion
//
//  Created by Kaka on 2017/2/14.
//  Copyright © 2017年 bzunion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainTabBar;

@protocol MainTabBarDelegate <NSObject>

@optional

- (void)tabBar:(MainTabBar *)tabBar didSelectedButtonFrom:(long)fromBtnTag to:(long)toBtnTag;

@end

@interface MainTabBar : UIView

@property(nonatomic, weak)id <MainTabBarDelegate>delegate;


- (void)addTabBarButtonWithTabBarItem:(UITabBarItem *)tabBarItem;

@end

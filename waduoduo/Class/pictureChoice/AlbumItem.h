//
//  AlbumItem.h
//  fanglian
//
//  Created by luobin on 2017/10/9.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>


//
/****************************
 *以相册的的子视图的控件
 *
 *
 */



@interface AlbumItem : UIScrollView

@property (nonatomic , strong) UIImageView *contentImage;

@property (nonatomic, assign) CGFloat itemWidth;//子视图的宽度

@property (nonatomic, assign) CGFloat itemHeight;//子视图的高度

@property (nonatomic, assign) CGFloat scalUse;

//添加图片显示
- (void)addTheImageViewWithItemImage:(UIImage *)itemImage;



@end






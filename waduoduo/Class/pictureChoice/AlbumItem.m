//
//  AlbumItem.m
//  fanglian
//
//  Created by luobin on 2017/10/9.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "AlbumItem.h"

#define ScreenBounds    (UIScreen.mainScreen.bounds)
#define ScreenWidth     (ScreenBounds.size.width)
#define ScreenHeight    (ScreenBounds.size.height)
#define navigationHeight (([UIScreen mainScreen].bounds.size.height-64)/504)
#define StatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define NavigationBarHeight (self.navigationController.navigationBar.bounds.size.height)

@implementation AlbumItem

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.userInteractionEnabled = YES;
        _scalUse = 1.0;
    }
    
    return self;
}

//添加图片显示
- (void)addTheImageViewWithItemImage:(UIImage *)itemImage {
    
    _contentImage = [[UIImageView alloc] init];
    _contentImage.image = itemImage;
    _contentImage.contentMode = UIViewContentModeScaleAspectFit;
    _contentImage.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    if (_itemHeight > 0) {
        _contentImage.frame = CGRectMake(0, 0, ScreenWidth, _itemHeight);
    } else {
        _itemHeight = ScreenHeight;
    }
    _contentImage.userInteractionEnabled = YES;
    
    [self addSubview:_contentImage];
    
    // 双击的 Recognizer
    UITapGestureRecognizer* doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapTheImage)];
    doubleRecognizer.numberOfTapsRequired = 2; // 双击
    //关键语句，给self.view添加一个手势监测；
    [_contentImage addGestureRecognizer:doubleRecognizer];
    
    // 关键在这一行，双击手势确定监测失败才会触发单击手势的相应操作
//    [singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];

    [_contentImage addGestureRecognizer:pinchGestureRecognizer];
    
}

//响应双击
- (void)doubleTapTheImage {
    
    if (_contentImage.frame.size.width == ScreenWidth) {
        self.contentSize = CGSizeMake(ScreenWidth * 2.0, ScreenHeight * 2.0);
        _contentImage.frame = CGRectMake(0, 0, ScreenWidth * 2.0, ScreenHeight * 2.0);
        self.contentOffset = CGPointMake(ScreenWidth * 0.5, ScreenHeight * 0.5);
        
    } else {
        self.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
        _contentImage.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    
}

//响应缩放的手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer {
    
    UIView *view = pinchGestureRecognizer.view;
    
//    NSLog(@"%f", _scalUse);
    
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        view.transform = CGAffineTransformScale(view.transform,
                                                 pinchGestureRecognizer.scale,
                                                 pinchGestureRecognizer.scale);
        
        pinchGestureRecognizer.scale = 1;
        
    }
    
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        if (view.frame.size.width < ScreenWidth) {
//            NSLog(@"缩小还原");
            [UIView animateWithDuration:0.3 animations:^{
                view.frame = CGRectMake(0, 0, ScreenWidth, self->_itemHeight);
                self.contentSize = CGSizeMake(ScreenWidth, self->_itemHeight);
                self.contentOffset = CGPointMake(0, 0);
            }];
            
        } else if (view.frame.size.width > ScreenWidth * 2) {
//            NSLog(@"放大还原");
            [UIView animateWithDuration:0.3 animations:^{
                view.frame = CGRectMake(0, 0, ScreenWidth * 2.0, self->_itemHeight * 2.0);
                self.contentSize = CGSizeMake(ScreenWidth * 2.0, self->_itemHeight * 2.0);
                self.contentOffset = CGPointMake(ScreenWidth * 0.5, self->_itemHeight * 0.5);
            }];
            
        } else {
            
            self.contentSize = CGSizeMake(view.frame.size.width, view.frame.size.height);
            self.contentOffset = CGPointMake((view.frame.size.width - ScreenWidth) * 0.5,
                                             (view.frame.size.height - _itemHeight) * 0.5);
            view.center = CGPointMake(view.frame.size.width * 0.5, view.frame.size.height * 0.5);
        }
        
//        NSLog(@"%@", view);
    }
    
}



@end








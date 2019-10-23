//
//  PickMainImageView.h
//  fanglian
//
//  Created by luobin on 2017/8/17.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PickMainImageView;

//接口声明
@protocol PickMainImageViewDelegate <NSObject>
@optional

- (void)deleteTheSelectImage:(PickMainImageView *)sender;


@end

@interface PickMainImageView : UIImageView

@property (nonatomic, assign) NSInteger               selfNum;
@property (nonatomic, assign) CGFloat               selfWidth;

@property (nonatomic , weak, nullable)id<PickMainImageViewDelegate>        delegate;

//添加子视图
- (void)addTheDeleteButton;



@end

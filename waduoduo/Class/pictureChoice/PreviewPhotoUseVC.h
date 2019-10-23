//
//  PreviewPhotoUseVC.h
//  fanglian
//
//  Created by luobin on 2018/4/16.
//  Copyright © 2018年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseChoseImageView;

@protocol PreviewPhotoUseVCProtocol <NSObject>
@optional
- (void)deletePhotoAndRefresh:(NSInteger)delNumber;

@end


//相册预览图片并且可以删除的视图控制器
@interface PreviewPhotoUseVC : UIViewController

@property (nonatomic, weak)BaseChoseImageView *editImageChoice;
@property (nonatomic, strong)NSMutableArray *imageArray;

@property (nonatomic, assign)NSInteger startImage;//判断最先开始显示哪一张图片

@property (nonatomic, weak) id<PreviewPhotoUseVCProtocol> delegate;

@end

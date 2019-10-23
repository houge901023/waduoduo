//
//  BaseChoseImageView.h
//  fanglian
//
//  Created by luobin on 2017/8/21.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickMainImageView.h"
@class BaseChoseImageView;

//接口声明
@protocol BaseChoseImageViewDelegate <NSObject>
@optional

- (void)choseTheImageForChoseView:(BaseChoseImageView *_Nullable)choseView;

- (void)previewWithTheBigTypeAndThePicNumber:(NSInteger)pickNumber;

- (void)deleImg;

@end

//
/****************************
 *用来给用户选择图片的控件
 *
 *
 */

//预览图片的类型的枚举
typedef enum _ImagePreviewType {
    PreviewWithAll  = 0,
    PreviewWithBigType
} ImagePreviewType;

@interface BaseChoseImageView : UIView <PickMainImageViewDelegate>

@property (nonatomic , weak, nullable)id<BaseChoseImageViewDelegate>        delegate;

@property (nonatomic , assign)NSInteger                       picNumber;//添加图片的最大数量

@property (nonatomic, strong, nullable) NSMutableArray                *imageArray;
@property (nonatomic, strong, nullable) NSMutableArray              *subviewArray;
//@property (nonatomic, strong, nullable) UIScrollView                *imageContent;

@property (nonatomic, strong) UIButton                                 *addPicBtn;
@property (nonatomic, strong) UILabel                                    *addTile;

@property (nonatomic, assign) CGFloat                                   itemWidth;

@property (nonatomic, assign) ImagePreviewType                        previewType;
@property (nonatomic, weak) UIViewController                     *AlbumEditPushVC; //用来推出管理相册图片的VC

//选择图片后刷新页面
- (void)reloadAllitemSubviewswithImage:(UIImage *)image;

//添加通过网络获取的图片
- (void)addTheImageFromTheIntenet:(NSString *)urlStr;

//通过输入删除序号来删除相应的图片
- (void)deleteThePictureWithTheCountNumber:(NSInteger)countNumber;


@end

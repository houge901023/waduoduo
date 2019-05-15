//
//  CollectionViewCell.h
//  waduoduo
//
//  Created by Apple  on 2019/4/22.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  CollectionViewCell;

@protocol  collectionCellDelegate

@optional

- (void)collectioncellTaped:(CollectionViewCell*)cell;

@end

NS_ASSUME_NONNULL_BEGIN

//上面是一个代理协议，某个CollectionViewCell被单击时候的回调，你可能是需要的，也可能不需要

@interface  CollectionViewCell :UICollectionViewCell

@property(nonatomic,strong) UIScrollView *contentScrollView; //用于实现缩放功能的UISCrollView

@property(nonatomic,strong) UIView *showView;//这个就是现实PDF文件内容的视图

@property(nonatomic,weak)id <collectionCellDelegate> cellTapDelegate;//代理

@end

NS_ASSUME_NONNULL_END

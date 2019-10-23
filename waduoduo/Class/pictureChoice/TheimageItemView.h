//
//  TheimageItemView.h
//  MobileOCC_Easywork
//
//  Created by llbt on 2019/3/21.
//  Copyright © 2019 ccb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TheimageItemView : UIView

@property (nonatomic, strong) NSMutableArray *imageUrls;
@property (nonatomic, strong) NSMutableArray *imageViews;

- (void)addTheSubviewsWithTheImageUrl;

@end

NS_ASSUME_NONNULL_END

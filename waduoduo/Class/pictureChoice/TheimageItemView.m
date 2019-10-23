//
//  TheimageItemView.m
//  MobileOCC_Easywork
//
//  Created by llbt on 2019/3/21.
//  Copyright © 2019 ccb. All rights reserved.
//

#import "TheimageItemView.h"
#import "SDWebImageManager.h"
#import "SDWebImageDownloader.h"
#import "UIImage+GIF.h"
#import "NSData+ImageContentType.h"


#define IMAGE_BUTTON_TAG 500;

@implementation TheimageItemView

- (instancetype)init{
    self = [super init];
    
    if (self) {
        self.userInteractionEnabled = YES;
        self.imageUrls = [[NSMutableArray alloc] init];
        self.imageViews = [[NSMutableArray alloc] init];
     }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)addTheSubviewsWithTheImageUrl {
    [self.imageViews removeAllObjects];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat imageWidth = ([UIScreen mainScreen].bounds.size.width - 70) / 3.0;
    
    for (int i = 0; i < self.imageUrls.count; i++) {
        
        NSInteger usex = i % 3;
        NSInteger usey = i / 3;
        
        UIImageView *itemview = [[UIImageView alloc] init];
        itemview.bounds = CGRectMake(0, 0, imageWidth, imageWidth);
        itemview.center = CGPointMake(10 + imageWidth * 0.5 + usex * imageWidth + 10 * usex, 10 + imageWidth * 0.5 + usey * (imageWidth + 10));
        NSString *itemUrl = self.imageUrls[i];
//        [itemview sd_setImageWithURL:[NSURL URLWithString:itemUrl] placeholderImage:[UIImage imageNamed:@"common_default_placeHolder"]];
        
        itemview.clipsToBounds = YES;
        itemview.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:itemview];
        [self.imageViews addObject:itemview];
    }
}

- (void)theViewButtonPressed {
    
}


- (void)setImageUrls:(NSMutableArray *)imageUrls {
    _imageUrls = imageUrls;
    
    if (_imageUrls.count > 0) {
        [self addTheSubviewsWithTheImageUrl];
    }
}


@end

//
//  shopsCell.m
//  yibaowang
//
//  Created by 名侯 on 16/12/5.
//  Copyright © 2016年 易小保网络科技. All rights reserved.
//

#import "shopsCell.h"

@implementation shopsCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setUp {
    
    _imageV = [[UIImageView alloc] init];
    [_imageV setContentMode:UIViewContentModeScaleAspectFill];
    _imageV.clipsToBounds = YES;
    [self.contentView addSubview:_imageV];
    
    _titleLB = [[UILabel alloc] init];
    _titleLB.textColor = titleC1;
    _titleLB.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_titleLB];
    
    _nameLB = [[UILabel alloc] init];
    _nameLB.textColor = titleC2;
    _nameLB.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_nameLB];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat W = self.bounds.size.width;
    
    _imageV.frame = CGRectMake(0, 0, W, W);
    _titleLB.frame = CGRectMake(10, W+5, W-20, 20);
    _nameLB.frame = CGRectMake(10, W+27, W-20, 15);
}

@end

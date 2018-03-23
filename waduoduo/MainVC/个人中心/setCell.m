//
//  setCell.m
//  waduoduo
//
//  Created by 名侯 on 2017/5/5.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import "setCell.h"

@implementation setCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    _titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 80, 20)];
    _titleLB.textColor = titleC1;
    _titleLB.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_titleLB];
    
    _valueLB = [[UILabel alloc] initWithFrame:CGRectMake(100, 12, SCREEN_WIDTH-115, 20)];
    _valueLB.textColor = titleC2;
    _valueLB.font = [UIFont systemFontOfSize:15];
    _valueLB.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_valueLB];
    
    _iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
    _iconImg.hidden = YES;
    [_iconImg setContentMode:UIViewContentModeScaleAspectFill];
    _iconImg.clipsToBounds = YES;
    _iconImg.layer.cornerRadius = 20;
    [self.contentView addSubview:_iconImg];
}

@end

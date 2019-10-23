//
//  headCollCell.m
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/12.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import "headCollCell.h"

@implementation headCollCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImg.layer.cornerRadius = 25;
    self.headImg.clipsToBounds = YES;
}

@end

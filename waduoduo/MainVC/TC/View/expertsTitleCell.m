//
//  expertsTitleCell.m
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/11.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import "expertsTitleCell.h"

@implementation expertsTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreAction:)];
    [self.moreView addGestureRecognizer:tap];
}

- (void)moreAction:(UITapGestureRecognizer *)tap {
    self.moreTap(tap.view.tag);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

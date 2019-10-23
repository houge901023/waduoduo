//
//  expertsListCell.m
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/13.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import "expertsListCell.h"

@implementation expertsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headImg.layer.cornerRadius = 45/2;
    self.headImg.clipsToBounds = YES;
    self.typeLB.textAlignment = NSTextAlignmentCenter;
    self.typeLB.layer.cornerRadius = 15/2;
    self.typeLB.layer.borderWidth = SCALELINEH;
    self.numLB.layer.cornerRadius = 10;
    self.numLB.clipsToBounds = YES;
}

- (void)setModel:(planListModel *)model {
    _model = model;
    
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.authheadImlUrl] placeholderImage:[UIImage imageNamed:@"people"]];
    self.nameLB.text = model.authName;
    self.introduceLB.text = model.authdescription;
    self.typeLB.text = model.authTag;

    self.hobbyLB.text = [NSString stringWithFormat:@"擅长：%@",model.authadvantage];
    self.numLB.text = model.explans;
    if (model.explans.intValue<1) {
        self.numLB.hidden = YES;
    }else {
        self.numLB.hidden = NO;
    }
    
//    CGFloat b = model.hitnum.floatValue/model.allnum.floatValue;
//    if (b>0.7) {
//        self.zhongLB.hidden = NO;
//        self.zhongLB.text = @" 超级盈利 ";
//    }else if(b<=0.7 && b>0.5){
//        self.zhongLB.hidden = NO;
//        self.zhongLB.text = @" 状态火热 ";
//    }else {
//        self.zhongLB.hidden = YES;
//    }
    
    self.typeLB.hidden = NO;
    self.typeWidth.constant = [model.authTag widthWithFont:12 h:16]+8;
    
    UIColor *typeColor;
    if ([model.authTag isEqualToString:@"彩票分析师"]) {
        typeColor = UIColorFromRGB(0xFFD700);
    }else if ([model.authTag isEqualToString:@"TV大咖"]) {
        typeColor = UIColorFromRGB(0xBC8F8F);
    }else if ([model.authTag isEqualToString:@"专业玩家"]) {
        typeColor = UIColorFromRGB(0xFF4500);
    }else if ([model.authTag isEqualToString:@"社区名人"]) {
        typeColor = UIColorFromRGB(0xE3A869);
    }else if ([model.authTag isEqualToString:@"媒体名记"]) {
        typeColor = UIColorFromRGB(0x00C78C);
    }else if ([model.authTag isEqualToString:@"足球名将"]) {
        typeColor = UIColorFromRGB(0x8A2BE2);
    }else {
        self.typeLB.hidden = YES;
    }
    self.typeLB.textColor = typeColor;
    self.typeLB.layer.borderColor = typeColor.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

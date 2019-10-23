//
//  expertsPlanCell.m
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/11.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import "expertsPlanCell.h"

@implementation expertsPlanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headImg.layer.cornerRadius = 20;
    self.headImg.clipsToBounds = YES;
    self.typeLB.textAlignment = NSTextAlignmentCenter;
    self.typeLB.layer.cornerRadius = 15/2;
    self.typeLB.layer.borderWidth = SCALELINEH;
    
    self.headImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTap:)];
    [self.headImg addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
   
}

- (void)setModel:(planListModel *)model {
    _model = model;
    
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.authheadImlUrl] placeholderImage:[UIImage imageNamed:@"people"]];
    self.nameLB.text = model.authName;
    self.introduceLB.text = model.authdescription;
    self.typeLB.text = model.authTag;
    self.titleLB.text = model.title;
    
//    if (model.hitnum.intValue>0) {
//        self.zhongLB.hidden = NO;
//        self.zhongLB.text = [NSString stringWithFormat:@" 近%@中%@ ",model.allnum,model.hitnum];
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

- (void)headTap:(UITapGestureRecognizer *)tap {
    self.headTap(tap.view.tag-300);
}

@end

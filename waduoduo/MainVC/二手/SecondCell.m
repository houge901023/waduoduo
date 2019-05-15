//
//  SecondCell.m
//  waduoduo
//
//  Created by Apple  on 2019/4/16.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import "SecondCell.h"

@implementation SecondCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(secondModel *)model {
    _model = model;
    
    self.titleLB.text = model.StkTitle;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IP,[model.PhotoPath substringFromIndex:3]]] placeholderImage:[UIImage imageNamed:@"wdd_placeholder"]];
    self.liuLanLB.text = [NSString stringWithFormat:@"%@人看过",model.liulanCount];
    self.timeLB.text = [self setString:model.LastDate];

    if ([model.WPrice doubleValue]>=10000) {
        NSString *str = [NSString changeFloatWithString:[NSString stringWithFormat:@"%.4f",[model.WPrice doubleValue]/10000]];
        NSString *str2 = [NSString stringWithFormat:@"%@万元",str];
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:str2];
        [attstr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(0, str.length)];
        self.priceLB.font = [UIFont systemFontOfSize:13];
        self.priceLB.attributedText = attstr;
    }else {
        if ([model.WPrice doubleValue] == 0) {
            self.priceLB.text = @"面议";
            self.priceLB.font = [UIFont systemFontOfSize:16];
        }else {
            NSString *str2 = [NSString stringWithFormat:@"%@元",model.WPrice];
            NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:str2];
            [attstr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(0, str2.length-1)];
            self.priceLB.font = [UIFont systemFontOfSize:13];
            self.priceLB.attributedText = attstr;
        }
    }
}

- (NSString *)setString:(NSString *)string {
    return [[string substringToIndex:string.length-3] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
}

@end

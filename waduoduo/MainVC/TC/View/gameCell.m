//
//  gameCell.m
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/13.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import "gameCell.h"

@implementation gameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}
- (void)setModel:(planTeamList *)model {
    _model = model;
    
    [self.homeImg sd_setImageWithURL:[NSURL URLWithString:model.homeTeamIcon] placeholderImage:[UIImage imageNamed:@"schdule_isOpen_down"]];
    [self.guestImg sd_setImageWithURL:[NSURL URLWithString:model.guestTeamIcon] placeholderImage:[UIImage imageNamed:@"schdule_isOpen_down"]];
    self.homeLB.text = model.homeTeam;
    self.guestLB.text = model.guestTeam;
    self.leagueLB.text = model.leagueName;
    self.timeLB.text = model.matchTime;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

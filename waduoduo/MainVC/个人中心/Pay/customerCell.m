//
//  customerCell.m
//  waduoduo
//
//  Created by Apple  on 2019/4/23.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import "customerCell.h"

@implementation customerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)teleAction:(UIButton *)sender {
    NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"tel:%@",sender.titleLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
}

@end

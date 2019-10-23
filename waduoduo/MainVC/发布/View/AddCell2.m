//
//  AddCell2.m
//  waduoduo
//
//  Created by Apple  on 2019/7/22.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import "AddCell2.h"

@implementation AddCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.introTV.placeHolder = @"请输入配件详细信息（不能带有敏感词及联系方式）";
    self.introTV.placeHolderTextColor = colorValue(0xcccccc, 1);
    self.introTV.disabelEmoji = YES;
    self.introTV.maxTextLength = 300;
    self.introTV.returnKeyType = UIReturnKeyDefault;
    self.introTV.textColor = colorValue(0x666666, 1);
    self.introTV.delegate = self;
    self.introTV.font = [UIFont systemFontOfSize:14];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(AddModel *)model {
    _model = model;
    
    self.introTV.text = model.intro;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.model.intro = self.introTV.text;
}
@end

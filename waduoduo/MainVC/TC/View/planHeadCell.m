//
//  planHeadCell.m
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/12.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import "planHeadCell.h"

@interface planHeadCell ()
{
    NSMutableArray *collecArr;
}

@property (weak, nonatomic) IBOutlet UIButton *collecBTn;
@property (nonatomic ,strong) NSString *nameClass;

@end

@implementation planHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headImg.layer.cornerRadius = 30;
    self.headImg.clipsToBounds = YES;
    self.typeLB.textAlignment = NSTextAlignmentCenter;
    self.typeLB.layer.cornerRadius = 15/2;
    self.typeLB.layer.borderWidth = SCALELINEH;
    
    collecArr = [[NSMutableArray alloc] initWithArray:[AVUser currentUser][@"collection"]];
    
}

- (void)setModel:(planDetailsModel *)model {
    _model = model;
    
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.authheadImlUrl] placeholderImage:[UIImage imageNamed:@"people"]];
    self.nameLB.text = model.authName;
    self.introduceLB.text = model.authdescription;
    self.typeLB.text = model.authTag;
    
    self.typeLB.hidden = NO;
    self.typeWidth.constant = [model.authTag widthWithFont:12 h:16]+8;
    if (model.authadvantage.length) {
        self.hobbyLB.text = [NSString stringWithFormat:@"擅长：%@",model.authadvantage];
        self.hobbyHeight.constant = 15;
    }else {
        self.hobbyHeight.constant = 0;
    }
    
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
        self.typeWidth.constant = 0;
    }
    self.typeLB.textColor = typeColor;
    self.typeLB.layer.borderColor = typeColor.CGColor;
    
    for (NSString *str1 in collecArr) { // 判断是否收藏
        NSArray  *array = [str1 componentsSeparatedByString:@"^"];
        NSString *str2 = array[0];
        if ([str2 isEqualToString:model.cauthorid]||[str2 isEqualToString:model.authorid]) {
            self.collecBTn.selected = YES;
        }
    }
    
    if (model.cauthorid.length>0) {
        self.nameClass = [NSString stringWithFormat:@"%@^%@^%@",model.cauthorid,model.authheadImlUrl,model.authName];
    }else if (model.authorid.length>0) {
        self.nameClass = [NSString stringWithFormat:@"%@^%@^%@",model.authorid,model.authheadImlUrl,model.authName];
    }
}

- (IBAction)focus:(UIButton *)sender {

    if (sender.selected) { 
        NSArray  *array = [self.nameClass componentsSeparatedByString:@"^"];
        NSString *str = array[0]; // 本地ID
        for (NSString *code1 in collecArr) {
            NSArray  *array = [code1 componentsSeparatedByString:@"^"];
            NSString *code2 = array[0];
            if ([code2 isEqualToString:str]) {
                [collecArr removeObject:code1];
                break;
            }
        }
        [self collecRequest:@"取消收藏成功" set:sender set:NO];
    }else {
        if (collecArr.count>=10) {
            [EasyTextView showInfoText:@"最多支持收藏10位专家，请整理个人收藏"];
            return;
        }
        sender.selected = YES;
        [collecArr addObject:self.nameClass];
        [self collecRequest:@"收藏成功" set:sender set:YES];
    }
}

#pragma mark -- 收藏的网络请求
- (void)collecRequest:(NSString *)msg set:(UIButton *)sender set:(BOOL)sele {
    
    AVUser *user = [AVUser currentUser];
    [user setObject:collecArr forKey:@"collection"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [EasyTextView showSuccessText:msg];
            sender.selected = sele;
        }else {
            [EasyTextView showErrorText:[NSString stringWithFormat:@"错误码：%ld",error.code]];
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

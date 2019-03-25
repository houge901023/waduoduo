//
//  DemandCell.m
//  waduoduo
//
//  Created by 名侯 on 2017/5/2.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import "DemandCell.h"
#import "SDWeiXinPhotoContainerView.h"

@implementation DemandCell
{
    UIImageView *headV;
    UILabel *nameLB;
    UILabel *tagLB;
    UILabel *connetLB;
    SDWeiXinPhotoContainerView *_picContainerView;
    UIButton *chatBtn;
    UILabel *dateLB;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    headV = [[UIImageView alloc] init];
    [self.contentView addSubview:headV];
    
    nameLB = [[UILabel alloc] init];
    nameLB.textColor = titleC1;
    nameLB.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:nameLB];
    
    tagLB = [[UILabel alloc] init];
    tagLB.textColor = [UIColor whiteColor];
    tagLB.font = [UIFont systemFontOfSize:14];
    tagLB.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:tagLB];
    
    connetLB = [[UILabel alloc] init];
    connetLB.textColor = titleC2;
    connetLB.font = [UIFont systemFontOfSize:16];
    connetLB.numberOfLines = 0;
    [self.contentView addSubview:connetLB];
    
    _picContainerView = [SDWeiXinPhotoContainerView new];
    
    chatBtn = [[UIButton alloc] init];
    [chatBtn setImage:[UIImage imageNamed:@"chat_2"] forState:UIControlStateNormal];
    [chatBtn addTarget:self action:@selector(chatAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:chatBtn];
    
    dateLB = [[UILabel alloc] init];
    dateLB.textColor = titleC3;
    dateLB.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:dateLB];
    
    NSArray *views = @[headV,nameLB,connetLB,_picContainerView,chatBtn,dateLB];
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;

    headV.sd_layout.leftSpaceToView(contentView,15)
    .topSpaceToView(contentView,10)
    .widthIs(60)
    .heightIs(60);
    
    nameLB.sd_layout.leftSpaceToView(headV,10)
    .topSpaceToView(contentView,20)
    .heightIs(15);
    
    tagLB.sd_layout.leftSpaceToView(nameLB,10)
    .centerYEqualToView(nameLB)
    .heightIs(20);
    
    connetLB.sd_layout.leftSpaceToView(headV,10)
    .topSpaceToView(nameLB,10)
    .rightSpaceToView(contentView,15)
    .autoHeightRatio(0);
    
    _picContainerView.sd_layout
    .leftEqualToView(connetLB);
    
    chatBtn.sd_layout.rightSpaceToView(contentView,15)
    .widthIs(30)
    .heightIs(30);
    
    dateLB.sd_layout.leftEqualToView(connetLB)
    .centerYEqualToView(chatBtn)
    .heightIs(15);
    
    [nameLB setSingleLineAutoResizeWithMaxWidth:100];
    [dateLB setSingleLineAutoResizeWithMaxWidth:100];
    headV.sd_cornerRadiusFromWidthRatio = @(0.5);
    tagLB.sd_cornerRadius = @(2);
}

- (void)setModel:(DemandModel *)model {
    
    _model = model;
    
    AVUser *user = model.user;
    
    
    [headV sd_setImageWithURL:[NSURL URLWithString:[user[@"iconHead"] imgUrlUpdate]] placeholderImage:[UIImage imageNamed:@"my_icon"]];
    headV.contentMode = UIViewContentModeScaleAspectFill;
    headV.layer.masksToBounds = YES;
    nameLB.text = avoidNull(model.user.username);
    
    if (model.lable.length) {
        tagLB.hidden = NO;
        NSString *num = [model.lable substringFromIndex:model.lable.length-1];
        NSString *str = [model.lable substringToIndex:model.lable.length-1];
        tagLB.text = str;
        tagLB.backgroundColor = @[mainBlue,mainGreen,mainYellow][num.intValue-1];
        tagLB.sd_layout.widthIs([XYString WidthForString:str withSizeOfFont:14]+8);
    }else {
        tagLB.hidden = YES;
    }
    
    if ([user.objectId isEqualToString:[AVUser currentUser].objectId]) {
        chatBtn.hidden = YES;
    }else {
        chatBtn.hidden = NO;
    }
    if (model.dele) {
        chatBtn.hidden = NO;
        [chatBtn setImage:[UIImage imageNamed:@"garbage"] forState:UIControlStateNormal];
    }
    
    connetLB.text = avoidNull(model.content);
    if (model.date.length>5) {
        dateLB.text = [model.date substringWithRange:NSMakeRange(5, 11)];
    }
    _picContainerView.picPathStringsArray = model.imgurlArr;
    _picContainerView.sd_layout.topSpaceToView(connetLB, 10);
    chatBtn.sd_layout.topSpaceToView(_picContainerView,5);
    
    [self setupAutoHeightWithBottomView:chatBtn bottomMargin:10];
}

- (void)chatAction {
    NSLog(@"kankan=%@",_model.lable);
    
    [self.delegate setObjectId:_model.user set:_model.imgurlArr set:_model.object];
}

@end

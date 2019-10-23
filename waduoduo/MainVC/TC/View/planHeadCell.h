//
//  planHeadCell.h
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/12.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "planDetailsModel.h"

@interface planHeadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *typeLB;
@property (weak, nonatomic) IBOutlet UILabel *hobbyLB;
@property (weak, nonatomic) IBOutlet UILabel *introduceLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hobbyHeight;

@property (nonatomic, strong) planDetailsModel *model;

@end

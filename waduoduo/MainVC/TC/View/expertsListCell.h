//
//  expertsListCell.h
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/13.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "planListModel.h"
@interface expertsListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *numLB;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *typeLB;
@property (weak, nonatomic) IBOutlet UILabel *hobbyLB;
@property (weak, nonatomic) IBOutlet UILabel *introduceLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeWidth;
@property (weak, nonatomic) IBOutlet UILabel *zhongLB;

@property (nonatomic) planListModel *model;

@end

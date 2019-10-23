//
//  gameCell.h
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/13.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "planDetailsModel.h"

@interface gameCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *homeImg;
@property (weak, nonatomic) IBOutlet UIImageView *guestImg;
@property (weak, nonatomic) IBOutlet UILabel *homeLB;
@property (weak, nonatomic) IBOutlet UILabel *guestLB;
@property (weak, nonatomic) IBOutlet UILabel *leagueLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (nonatomic) planTeamList *model;
@end

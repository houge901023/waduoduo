//
//  planTitleCell.h
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/12.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface planTitleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *typeLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeWidth;
@property (weak, nonatomic) IBOutlet UILabel *orderLB;
@end

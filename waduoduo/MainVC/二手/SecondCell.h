//
//  SecondCell.h
//  waduoduo
//
//  Created by Apple  on 2019/4/16.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "secondModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SecondCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *liuLanLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (nonatomic ,strong)secondModel *model;

@end

NS_ASSUME_NONNULL_END

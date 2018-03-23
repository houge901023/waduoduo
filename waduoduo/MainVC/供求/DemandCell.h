//
//  DemandCell.h
//  waduoduo
//
//  Created by 名侯 on 2017/5/2.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemandModel.h"

@protocol Demanddelegate <NSObject>

- (void)setObjectId:(AVUser *)user set:(NSArray *)imgUrl set:(AVObject *)object;

@end

@interface DemandCell : UITableViewCell

@property (nonatomic ,strong) DemandModel *model;
@property (nonatomic ,assign) id <Demanddelegate> delegate;

@end

//
//  PlanDetailsVC.h
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/12.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import "BaseVController.h"

@interface PlanDetailsVC : BaseVController

@property (nonatomic ,copy) NSString *planNo;
@property (nonatomic ,copy) NSString *type;
@property (nonatomic ,assign) BOOL history;

@end

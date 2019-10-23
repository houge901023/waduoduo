//
//  HistoryListVC.h
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/16.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import "BaseVController.h"

@interface HistoryListVC : BaseVController

@property (nonatomic ,copy) NSString *type;
@property (nonatomic ,copy) NSString *ExpertsNo;
@property (nonatomic, strong) UITableView *mainTV;

@end

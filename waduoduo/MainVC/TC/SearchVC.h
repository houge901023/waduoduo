//
//  SearchVC.h
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/14.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import "BaseVController.h"

@interface SearchVC : BaseVController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHeight;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UITableView *contentTV;

@end

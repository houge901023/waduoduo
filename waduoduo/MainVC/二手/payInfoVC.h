//
//  payInfoVC.h
//  waduoduo
//
//  Created by Apple  on 2019/4/23.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface payInfoVC : BaseVC

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

@property (nonatomic ,assign) BOOL isSuccess;
@property (nonatomic ,strong) NSString *tel;

@end

NS_ASSUME_NONNULL_END

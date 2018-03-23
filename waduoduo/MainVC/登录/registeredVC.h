//
//  registeredVC.h
//  waduoduo
//
//  Created by 名侯 on 2017/4/24.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import "BaseVC.h"

@interface registeredVC : BaseVC

@property (nonatomic ,strong) void (^success)(NSString *phone,NSString *pass);

@end

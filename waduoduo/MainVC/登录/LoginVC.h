//
//  LoginVC.h
//  waduoduo
//
//  Created by 名侯 on 2017/4/24.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import "BaseVC.h"

typedef void (^LoginUserIfo)();

@interface LoginVC : BaseVC

@property (nonatomic ,copy) LoginUserIfo info;

+ (void)LoginSuccess:(LoginUserIfo)info;


@end

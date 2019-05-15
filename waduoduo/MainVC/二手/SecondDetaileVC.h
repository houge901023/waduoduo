//
//  SecondDetaileVC.h
//  waduoduo
//
//  Created by Apple  on 2019/4/22.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import "BaseVC.h"
#import "secondModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SecondDetaileVC : BaseVC

@property (nonatomic ,strong) secondModel *model;
@property (nonatomic ,assign) BOOL isHiden;

@end

NS_ASSUME_NONNULL_END

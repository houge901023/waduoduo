//
//  DemandModel.h
//  waduoduo
//
//  Created by 名侯 on 2017/5/2.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemandModel : NSObject

@property (nonatomic ,copy) NSString *lable;
@property (nonatomic ,copy) NSString *content;
@property (nonatomic ,copy) NSString *date;
@property (nonatomic ,strong) NSArray *imgurlArr;
@property (nonatomic ,strong) AVUser *user;
@property (nonatomic ,strong) AVObject *object;
@property (nonatomic ,assign) BOOL dele;

@end

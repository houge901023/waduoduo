//
//  InfoData.h
//  SouMi
//
//  Created by Apple  on 2019/4/10.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface API_Urls : NSObject

@property (nonatomic ,strong) NSString *match_managerment_list; // 积分榜

@end

@interface InfoData : NSObject

@property (nonatomic ,strong) NSString *base;
@property (nonatomic ,strong) API_Urls *urls;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END

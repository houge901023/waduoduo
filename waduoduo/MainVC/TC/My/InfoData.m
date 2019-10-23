//
//  InfoData.m
//  SouMi
//
//  Created by Apple  on 2019/4/10.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import "InfoData.h"

@implementation InfoData

static id instance_;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [[self alloc] init];
    });
    return instance_;
}

+ (NSDictionary *)objectClassInArray{
    return @{@"urls":[API_Urls class]};
}

@end

@implementation API_Urls


@end

//
//  planDetailsModel.h
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/12.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import <Foundation/Foundation.h>

// 比赛
@interface planTeamList : NSObject

@property (nonatomic, copy) NSString *raceNo;
@property (nonatomic, copy) NSString *homeTeam;
@property (nonatomic, copy) NSString *leagueName;
@property (nonatomic, copy) NSString *guestTeam;
@property (nonatomic, copy) NSString *homeTeamIcon;
@property (nonatomic, copy) NSString *guestTeamIcon;
@property (nonatomic, copy) NSString *matchTime;

@end

// 未开赛
@interface NotStartList : NSObject

@property (nonatomic, copy) NSString *lotterytype;
@property (nonatomic, copy) NSString *plantitle;
@property (nonatomic, copy) NSString *begintime;
@property (nonatomic, copy) NSString *cprojid;

@end

@interface planDetailsModel : NSObject

@property (nonatomic, copy) NSString *authheadImlUrl;
@property (nonatomic, copy) NSString *authName;
@property (nonatomic, copy) NSString *authTag;
@property (nonatomic, copy) NSString *authdescription;
@property (nonatomic, copy) NSString *plantitle;
@property (nonatomic, copy) NSString *projid;
@property (nonatomic, copy) NSString *begintime;
@property (nonatomic, copy) NSString *releaseTime;
@property (nonatomic, copy) NSString *plansummary;
@property (nonatomic, copy) NSString *plandescription;
@property (nonatomic, copy) NSString *lotterytype; // 比赛类型
@property (nonatomic, copy) NSString *authadvantage; // 擅长
@property (nonatomic, copy) NSString *allnum;
@property (nonatomic, copy) NSString *hitnum;
@property (nonatomic, copy) NSString *cauthorid;
@property (nonatomic, copy) NSString *authorid;
@property (nonatomic, strong) NSArray<planTeamList *> * planforecastitems; // 比赛数组
@property (nonatomic, strong) NSArray<NotStartList *> * explanlists; // 未开赛数组

@end

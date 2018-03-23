//
//  OlddriversVC.m
//  waduoduo
//
//  Created by 名侯 on 2017/4/20.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import "OlddriversVC.h"
#import "chatVC.h"

@interface OlddriversVC () <RCIMUserInfoDataSource>

@end

@implementation OlddriversVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    
    UIView *nilView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44)];
    nilView.backgroundColor = BackGroundColor;
    self.emptyConversationView = nilView;
    self.conversationListTableView.tableFooterView = [[UIView alloc] init];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(refresh) userInfo:nil repeats:NO];
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    chatVC *conversationVC = [[chatVC alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = avoidNull(model.conversationTitle);
    [self.navigationController pushViewController:conversationVC animated:YES];
}

#pragma mark -- 融云会话列表
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
    NSLog(@"用户id=%@",userId);
    
    AVUser *bbb = [AVQuery getUserObjectWithId:userId];
    
    RCUserInfo *use = [[RCUserInfo alloc] init];
    use.name = avoidNull(bbb.username);
    use.portraitUri = bbb[@"iconHead"];
    completion(use);
}

- (void)refresh {
    [self.conversationListTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  chatVC.m
//  textRY
//
//  Created by 名侯 on 16/11/13.
//  Copyright © 2016年 侯彦名. All rights reserved.
//

#import "chatVC.h"
#import "OthersInfoVC.h"

@interface chatVC () <RCIMUserInfoDataSource>

@end

@implementation chatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    
    //工具栏增加发送文件
    UIImage *imageFile = [RCKitUtility imageNamed:@"actionbar_file_icon"
                                         ofBundle:@"RongCloud.bundle"];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:imageFile
                                        title:@"发送文件"
                                      atIndex:3
                                          tag:PLUGIN_BOARD_ITEM_FILE_TAG];
    
    //用户自己的头像
    RCUserInfo *use = [[RCUserInfo alloc] init];
    use.userId = [AVUser currentUser].objectId;
    use.portraitUri = avoidNull([AVUser currentUser][@"iconHead"]);
    [RCIM sharedRCIM].currentUserInfo = use;

}

#pragma mark -- 点击聊天界面头像
- (void)didTapCellPortrait:(NSString *)userId {
    if ([[AVUser currentUser].objectId isEqualToString:userId]) {
        return;
    }
    
    NSLog(@"点击了%@",userId);
    [self othersInfo:userId];
}

#pragma mark -- 他人信息
- (void)othersInfo:(NSString *)uid {
    
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [SVProgressHUD showWithStatus:@"读取中..."];
    [query getObjectInBackgroundWithId:uid block:^(AVObject * _Nullable object, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"kankan=%@",object);
            NSString *tele = avoidNull(object[@"mobilePhoneNumber"]);
            if (tele.length>8) {
                tele = [NSString stringWithFormat:@"%@****%@",[tele substringToIndex:3],[tele substringFromIndex:7]];
            }
            NSArray *arr = @[tele,avoidNull(object[@"objectId"]),
                             avoidNull(object[@"company"]),avoidNull(object[@"usertype"]),
                             avoidNull(object[@"model"]),avoidNull(object[@"usercity"]),
                             avoidNull(object[@"userinfo"])];
            OthersInfoVC *MVC = [[OthersInfoVC alloc] init];
            MVC.dataArr = arr;
            MVC.name = avoidNull(object[@"username"]);
            MVC.imgurl = avoidNull(object[@"iconHead"]);
            [self.navigationController pushViewController:MVC animated:YES];
            [SVProgressHUD dismiss];
        }else {
            [SVProgressHUD showMessage:@"读取失败，稍后重试"];
        }
    }];
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

//
//  DemandVC.m
//  waduoduo
//
//  Created by 名侯 on 2017/4/20.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import "DemandVC.h"
#import "DemandCell.h"
#import "MJRefresh.h"
#import "chatVC.h"
#import "LQPopUpView.h"

@interface DemandVC () <UITableViewDelegate,UITableViewDataSource,Demanddelegate,RCIMUserInfoDataSource>

@property (nonatomic ,strong) UIButton *imgNil;
@property (nonatomic ,strong) UITableView *mainTV;
@property (nonatomic ,strong) NSMutableArray *dataArr;

@end

@implementation DemandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self request];
    
    _imgNil = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    _imgNil.hidden = YES;
    _imgNil.userInteractionEnabled = NO;
    _imgNil.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [_imgNil setImage:[UIImage imageNamed:@"data_nil"] forState:UIControlStateNormal];
    [_imgNil setTitle:@"空，快去发布～" forState:UIControlStateNormal];
    [_imgNil setTitleColor:titleC3 forState:UIControlStateNormal];
    _imgNil.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_imgNil];
    
    CGFloat w = [XYString WidthForString:@"空，快去发布～" withSizeOfFont:12];
    [_imgNil setTitleEdgeInsets:UIEdgeInsetsMake(60, 0, 0, 80)];
    [_imgNil setImageEdgeInsets:UIEdgeInsetsMake(0, w, 40, 0)];
}

- (NSMutableArray *)dataArr {
    if (_dataArr==nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)setup {
    
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    
    CGFloat height;
    if (self.userId) {
        height = JLNavH;
    }else {
        height = JLNavH+49;
    }
    
    _mainTV = [[UITableView alloc] initWithFrame:CGRectMake(0, JLNavH, SCREEN_WIDTH, SCREEN_HEIGHT-height) style:UITableViewStylePlain];
    _mainTV.backgroundColor = [UIColor clearColor];
    _mainTV.delegate = self;
    _mainTV.dataSource = self;
    [self.view addSubview:_mainTV];
    _mainTV.tableFooterView = [[UIView alloc] init];
    
    _mainTV.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataArr removeAllObjects];
        [self request];
    }];
    _mainTV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadLastData)];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DemandModel *demoVC14Modelodel = self.dataArr[indexPath.row];
    
    return [self.mainTV cellHeightForIndexPath:indexPath model:demoVC14Modelodel keyPath:@"model" cellClass:[DemandCell class] contentViewWidth:SCREEN_WIDTH];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    DemandCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[DemandCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArr[indexPath.row];
    cell.delegate = self;
    
    return cell;
}

- (void)loadLastData {
    [self request];
}

#pragma mark -- 网络请求
- (void)request {
    
    AVQuery *query = [AVQuery queryWithClassName:@"Demand"];
    
    if (self.userId) {
        [query whereKey:@"userId" hasPrefix:self.userId];
    }
    
    [query orderByDescending:@"createdAt"];//排序方式
    [query setLimit:8];
    [query setSkip:self.dataArr.count];
    [query includeKey:@"owner"];
    
    [SVProgressHUD showWithStatus:nil];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [_mainTV.mj_header endRefreshing];
        [_mainTV.mj_footer endRefreshing];
        if (!error) {

            if (objects.count) {
                self.imgNil.hidden = YES;
                [SVProgressHUD dismiss];
                for (AVObject *object in objects) {
                    AVUser *user = object[@"owner"];
                    DemandModel *model = [[DemandModel alloc] init];
                    model.object = object;
                    model.user = user;
                    model.content = [NSString stringWithFormat:@"%@",object[@"content"]];
                    model.lable = [NSString stringWithFormat:@"%@",object[@"lable"]];
                    model.date = [NSString stringWithFormat:@"%@",object[@"date"]];
                    model.imgurlArr = [object[@"image"] componentsSeparatedByString:@","];
                    model.dele = self.Personal;
                    [self.dataArr addObject:model];
                }
                [_mainTV reloadData];
            }else {
                if (self.dataArr.count) {
                    self.imgNil.hidden = YES;
                    [SVProgressHUD showMessage:@"无更多数据"];
                }else {
                    self.imgNil.hidden = NO;
                    [_mainTV reloadData];
                    [SVProgressHUD dismiss];
                }
            }
        }else {
            [SVProgressHUD showMessage:@"服务器繁忙，稍后重试"];
        }
    }];
}

#pragma mark -- 点击会话的代理
- (void)setObjectId:(AVUser *)user set:(NSArray *)imgUrl set:(AVObject *)object {
   
    if ([AVUser currentUser]==nil) {
        [SVProgressHUD showMessage:@"请先登录"];
        return;
    }
    if ([[AVUser currentUser].objectId isEqualToString:self.userId]) {
        
        LQPopUpView *popUpView = [[LQPopUpView alloc] initWithTitle:@"提示" message:@"是否确定删除信息"];
        
        [popUpView addBtnWithTitle:@"取消" type:LQPopUpBtnStyleCancel handler:^{
            // do something...
        }];
        
        [popUpView addBtnWithTitle:@"确定" type:LQPopUpBtnStyleDefault handler:^{
            [object deleteInBackground];
            [self.navigationController popToRootViewControllerAnimated:YES];
        
            AVQuery *query = [AVQuery queryWithClassName:@"_File"];
            [query whereKey:@"url" containedIn:imgUrl];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if (objects.count) {
                    for (AVFile *file in objects) {
                        [file deleteInBackground];
                    }
                }
            }];
        }];
        
        [popUpView showInView:self.view preferredStyle:LQPopUpViewStyleAlert];
    }else {
        
        if (APP_DELE.newV==NO) {
            [SVProgressHUD showErrorWithStatus:@"请更新版本"];
            return;
        }
        
        chatVC *conversationVC = [[chatVC alloc]init];
        conversationVC.conversationType = ConversationType_PRIVATE;
        conversationVC.targetId = user.objectId;
        conversationVC.title = user.username;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
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

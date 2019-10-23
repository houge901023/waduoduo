//
//  MainVC.m
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/11.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import "MainVC.h"
#import "ExpertsVC.h"
#import "expertsHeadCell.h"
#import "expertsPlanCell.h"
#import "expertsTitleCell.h"
#import "planListModel.h"
//#import "UIImage+HG.h"
#import "PlanDetailsVC.h"
#import "ExpertsDetailsVC.h"
#import "SearchVC.h"
#import "MorePlanVC.h"
#import "LoginVC.h"
#import "MyFocusVC.h"
#import "MyPlanVC.h"
#import "webVC.h"
#import "NSDate+Utils.h"
#import "InfoData.h"

static NSString * const ExpertsHeadCellID = @"ExpertsHeadCellID"; //推荐专家
static NSString * const ExpertsPlanCellID = @"ExpertsPlanCellID"; //推荐方案
static NSString * const ExpertsTitleCellID = @"ExpertsTitleCellID"; //标题

@interface MainVC () <UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>

@property (nonatomic, weak) UITableView *mainTV;
@property (nonatomic, weak) UIImageView *peopleImgV; // 头像
@property (nonatomic, strong) NSMutableArray *headArr; // 专家
@property (nonatomic, strong) NSMutableArray *planArr; // 方案
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSDateFormatter *format;

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收米";
    
    [self.NavRight setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    
    [self setUI];
    self.page = 1;
    [self setRequst:YES];
    
    WEAKSELF;
    // 加载状态回调
    [self.view loadStateReturnBlock:^(ViewStateReturnType viewStateReturnType) {
        if (viewStateReturnType == ViewStateReturnReloadViewDataType) {//用户点击了重新加载
            // 显示加载中
            [weakSelf.view showLoadStateWithMaskViewStateType:viewStateWithLoading];
            // 重新请求数据
            [weakSelf setRequst:YES];
        }
    }];
    
    [self PlanInit];
    [self setMainRequest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)headArr {
    if (_headArr == nil) {
        _headArr = [NSMutableArray array];
    }
    return _headArr;
}
- (NSMutableArray *)planArr {
    if (_planArr == nil) {
        _planArr = [NSMutableArray array];
    }
    return _planArr;
}

#pragma mark -- 搜索点击
- (void)rightAction {
    SearchVC *MVC = [[SearchVC alloc] init];
    [self.navigationController pushViewController:MVC animated:YES];
}

- (void)setUI {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, JLNavH, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    [tableView setSeparatorColor:UIColorFromRGB(0xeeeeee)];
    [tableView registerClass:[expertsHeadCell class] forCellReuseIdentifier:ExpertsHeadCellID];
    [tableView registerNib:[UINib nibWithNibName:@"expertsPlanCell" bundle:nil] forCellReuseIdentifier:ExpertsPlanCellID];
    [tableView registerNib:[UINib nibWithNibName:@"expertsTitleCell" bundle:nil] forCellReuseIdentifier:ExpertsTitleCellID];
    //不使用nib时注册cell
    [self.view addSubview:tableView];
    tableView.tableFooterView = [[UIView alloc] init];
    self.mainTV = tableView;
    tableView.mj_header = self.MJHeader;
    tableView.mj_footer = self.MJFooter;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)loadNewData {
    self.page = 1;
    [self setRequst:NO];
}
- (void)loadMoreData {
    self.page++;
    [self setRequsetPlan:NO];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==3) {
        return self.planArr.count;
    }else {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.headArr.count>0) {
        if (section==1) {
            return 8;
        }else if (section==3) {
            return CGFLOAT_MIN;
        }else {
            return 1;
        }
    }else {
        if (section==3) {
            return CGFLOAT_MIN;
        }else {
            return 1;
        }
    }
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return self.headArr.count>0 ? 40:0.0;
    }else if (indexPath.section==1) {
        
        if (self.headArr.count>0 && self.headArr.count<5) {
            return 90;
        }else if (self.headArr.count>4) {
            return 180;
        }else {
            return 0;
        }
        
        
    }else if (indexPath.section==2) {
        return self.planArr.count>0 ? 40:0.0;
    }else {
        return 100;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        expertsTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:ExpertsTitleCellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"expertsTitleCell" owner:nil options:nil] firstObject];
        }
        cell.titleLB.text = @"推荐专家";
        cell.moreView.tag = 100;
        WEAKSELF;
        [cell setMoreTap:^(NSInteger tag) {
            if (tag==100) {
                ExpertsVC *MVC = [[ExpertsVC alloc] init];
                [weakSelf.navigationController pushViewController:MVC animated:YES];
            }
        }];
        
        return cell;
    }else if (indexPath.section == 1) {
        expertsHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:ExpertsHeadCellID];
        if (self.headArr.count>0) {
            cell.dataArr = self.headArr;
        }
        WEAKSELF;
        [cell setHeadTap:^(NSInteger index) {
            planListModel *model = self.headArr[index];
            ExpertsDetailsVC *MVC = [[ExpertsDetailsVC alloc] init];
            MVC.ExpertsNo = model.authName;
            [weakSelf.navigationController pushViewController:MVC animated:YES];
        }];
        return cell;
    }else if (indexPath.section == 2) {
        expertsTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:ExpertsTitleCellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"expertsTitleCell" owner:nil options:nil] firstObject];
        }
        cell.moreView.tag = 101;
        WEAKSELF;
        [cell setMoreTap:^(NSInteger tag) {
            if (tag==101) {
                MorePlanVC *MVC = [[MorePlanVC alloc] init];
                [weakSelf.navigationController pushViewController:MVC animated:YES];
            }
        }];
        return cell;
    }else {
        expertsPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:ExpertsPlanCellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"expertsPlanCell" owner:nil options:nil] firstObject];
        }
        cell.headImg.tag = 300+indexPath.row;
        cell.model = self.planArr[indexPath.row];
        WEAKSELF;
        [cell setHeadTap:^(NSInteger index) {
            planListModel *model = self.planArr[index];
            ExpertsDetailsVC *MVC = [[ExpertsDetailsVC alloc] init];
            MVC.ExpertsNo = model.authName;
            [weakSelf.navigationController pushViewController:MVC animated:YES];
        }];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        planListModel *model = self.planArr[indexPath.row];
        PlanDetailsVC *MVC = [[PlanDetailsVC alloc] init];
        MVC.planNo = model.dbno;
        MVC.type = model.lotterytype;
        [self.navigationController pushViewController:MVC animated:YES];
    }
}
- (void)setRequst:(BOOL)init {
    
    if (init) {
        [self.view showLoadStateWithMaskViewStateType:viewStateWithLoading];
    }
    // 专家数据
    [BaseRequest get:@"/getFamousLists.phpx?channel=159cai&version=1&page=1" parameters:nil success:^(id responseObj) {
        NSArray *arr = responseObj[@"Resp"][@"rows"][@"row"];
        [self.headArr removeAllObjects];
        for (NSDictionary *dic in arr) {
            planListModel *model = [planListModel mj_objectWithKeyValues:dic];
            [self.headArr addObject:model];
        }
        [self setRequsetPlan:init];
    } failure:^(NSError *error) {
        [self setRequsetPlan:init];
    }];
}

- (void)setRequsetPlan:(BOOL)init {
    
    [BaseRequest get:@"/getExplainList.phpx?channel=159cai&version=1&playType=0&type=0&name=rq" parameters:@{@"pn":@(self.page)} success:^(id responseObj) {
        if (init) {
            [self.view dismessStateView];
        }else{
            [self.mainTV.mj_header endRefreshing];
            [self.mainTV.mj_footer endRefreshing];
        }
        NSArray *arr = responseObj[@"Resp"][@"rows"][@"row"];
        if (self.page==1) {
            [self.planArr removeAllObjects];
        }
        if (arr.count==0) {
            [self.mainTV.mj_footer endRefreshingWithNoMoreData];
        }else {
            for (NSDictionary *dic in arr) {
                planListModel *model = [planListModel mj_objectWithKeyValues:dic];
                [self.planArr addObject:model];
            }
            [self.mainTV reloadData];
        }
    } failure:^(NSError *error) {
        if (init) {
            [self.view showLoadStateWithMaskViewStateType:viewStateWithLoadError];
        }else {
            [self.mainTV.mj_header endRefreshing];
            [self.mainTV.mj_footer endRefreshing];
        }
    }];
}

- (void)PlanInit {
    
    NSMutableArray *zqArr = [[NSMutableArray alloc] initWithArray:[AVUser currentUser][@"plan"]];
    NSMutableArray *zhArr = [[NSMutableArray alloc] init];
    for (NSString *str in zqArr) {
        NSArray  *array = [str componentsSeparatedByString:@"^"];
        NSString *time = array[2];
        NSDate *data = [self.format dateFromString:time];
        NSInteger a = [data daysBetweenCurrentDateAndDate];
        if (a > -7) {
            [zhArr addObject:str];
        }
    }
    
    AVUser *user = [AVUser currentUser];
    [user setObject:zhArr forKey:@"plan"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
    }];
}

- (NSDateFormatter *)format {
    if (_format == nil) {
        _format = [[NSDateFormatter alloc] init];
        _format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _format;
}

- (void)setMainRequest {
    
    AVQuery *query = [AVQuery queryWithClassName:@"AD"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count>0) {
                [[NSUserDefaults standardUserDefaults] setObject:objects[0][@"image_url"] forKey:StartAD_imageUrl];
            }
        }
    }];
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

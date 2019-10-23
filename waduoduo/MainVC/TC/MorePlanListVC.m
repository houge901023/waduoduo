//
//  MorePlanListVC.m
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/16.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import "MorePlanListVC.h"
#import "expertsPlanCell.h"
#import "PlanDetailsVC.h"
#import "ExpertsDetailsVC.h"

static NSString * const ExpertsPlanCellID = @"ExpertsPlanCellID"; //推荐方案

@interface MorePlanListVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *planArr; // 方案
@property (nonatomic, assign) NSInteger page;

@end

@implementation MorePlanListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainTV.stateView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH-48);
    self.page=1;
    [self setRequsetPlan:YES];
}
- (NSMutableArray *)planArr {
    if (_planArr == nil) {
        _planArr = [NSMutableArray array];
    }
    return _planArr;
}
- (UITableView *)mainTV {
    if (_mainTV == nil) {
        _mainTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH-40) style:UITableViewStyleGrouped];
        _mainTV.delegate = self;
        _mainTV.dataSource = self;
        _mainTV.backgroundColor = [UIColor clearColor];
        _mainTV.showsVerticalScrollIndicator = NO;
        _mainTV.estimatedSectionHeaderHeight = 0;
        _mainTV.estimatedSectionFooterHeight = 0;
        [_mainTV setSeparatorColor:UIColorFromRGB(0xeeeeee)];
        _mainTV.estimatedRowHeight = 666;
        _mainTV.rowHeight = UITableViewAutomaticDimension;
        [_mainTV registerNib:[UINib nibWithNibName:@"expertsPlanCell" bundle:nil] forCellReuseIdentifier:ExpertsPlanCellID];
        _mainTV.mj_header = self.MJHeader;
        _mainTV.mj_footer = self.MJFooter;
        if (@available(iOS 11.0, *)) {
            _mainTV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mainTV;
}
- (void)loadNewData {
    self.page = 1;
    [self setRequsetPlan:NO];
}
- (void)loadMoreData {
    self.page++;
    [self setRequsetPlan:NO];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.planArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    planListModel *model = self.planArr[indexPath.row];
    PlanDetailsVC *MVC = [[PlanDetailsVC alloc] init];
    MVC.planNo = model.dbno;
    MVC.type = model.lotterytype;
    [self.navigationController pushViewController:MVC animated:YES];
}

- (void)setRequsetPlan:(BOOL)init {
    
    if (init) {
        [self.mainTV showLoadStateWithMaskViewStateType:viewStateWithLoading];
    }
    
    [BaseRequest get:@"/getHomePageJS.php" parameters:@{@"type":@"0", @"page":@(self.page),@"playtype":self.type} success:^(id responseObj) {
        NSArray *arr = responseObj[@"data"];
        if (![arr isKindOfClass:[NSArray class]]) {
            [self.mainTV showLoadStateWithMaskViewStateType:viewStateWithEmpty];
            [self.mainTV.mj_header endRefreshing];
            [self.mainTV.mj_footer endRefreshing];
            return;
        }
        if (init) {
            if (arr.count==0) {
                [self.mainTV showLoadStateWithMaskViewStateType:viewStateWithEmpty];
            }else {
                [self.mainTV dismessStateView];
            }
        }else{
            [self.mainTV.mj_header endRefreshing];
            [self.mainTV.mj_footer endRefreshing];
        }
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
            [self.mainTV showLoadStateWithMaskViewStateType:viewStateWithLoadError];
        }else {
            [self.mainTV.mj_header endRefreshing];
            [self.mainTV.mj_footer endRefreshing];
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

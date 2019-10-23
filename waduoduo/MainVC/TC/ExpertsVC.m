//
//  ExpertsVC.m
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/11.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import "ExpertsVC.h"
#import "expertsListCell.h"
#import "planListModel.h"
#import "ExpertsDetailsVC.h"
#import "SearchVC.h"

static NSString * const ExpertsListCellID = @"ExpertsListCellID"; //标题

@interface ExpertsVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *mainTV;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;

@end

@implementation ExpertsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专家列表";
    [self.NavRight setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    
    self.page=1;
    [self setUI];
    [self setRequest:YES];
    
}
- (NSMutableArray *)dataArr {
    if (_dataArr==nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
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
    [tableView registerNib:[UINib nibWithNibName:@"expertsListCell" bundle:nil] forCellReuseIdentifier:ExpertsListCellID];
    [self.view addSubview:tableView];
    tableView.tableFooterView = [[UIView alloc] init];
    self.mainTV = tableView;
    tableView.mj_header = self.MJHeader;
    tableView.mj_footer = self.MJFooter;
//    [self.MJHeader setTitle:@"按准确率排序" forState:MJRefreshStateWillRefresh];
//    [self.MJHeader setTitle:@"按准确率排序" forState:MJRefreshStateRefreshing];
//    [self.MJHeader setTitle:@"按准确率排序" forState:MJRefreshStatePulling];
//    [self.MJHeader setTitle:@"按准确率排序" forState:MJRefreshStateIdle];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
}
- (void)loadNewData {
    self.page=1;
    [self setRequest:NO];
}
- (void)loadMoreData {
    self.page++;
    [self setRequest:NO];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    expertsListCell *cell = [tableView dequeueReusableCellWithIdentifier:ExpertsListCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"expertsListCell" owner:nil options:nil] firstObject];
    }
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    planListModel *model = self.dataArr[indexPath.row];
    ExpertsDetailsVC *MVC = [[ExpertsDetailsVC alloc] init];
    MVC.ExpertsNo = model.authName;
    [self.navigationController pushViewController:MVC animated:YES];
}
- (void)setRequest:(BOOL)init {
    if (init) {
        [self.view showLoadStateWithMaskViewStateType:viewStateWithLoading];
    }
    
    [BaseRequest get:@"/getFamousLists.phpx?channel=159cai&version=1&page=1" parameters:@{@"pn":@(self.page)} success:^(id responseObj) {
        if (init) {
            [self.view dismessStateView];
        }else{
            [self.mainTV.mj_header endRefreshing];
            [self.mainTV.mj_footer endRefreshing];
        }
        NSArray *arr = responseObj[@"Resp"][@"rows"][@"row"];
        if (self.page==1) {
            [self.dataArr removeAllObjects];
        }
        if (arr.count==0) {
            [self.mainTV.mj_footer endRefreshingWithNoMoreData];
        }else {
            for (NSDictionary *dic in arr) {
                planListModel *model = [planListModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
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

//
//  SecondHandVC.m
//  waduoduo
//
//  Created by Apple  on 2019/4/16.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import "SecondHandVC.h"
#import "SecondCell.h"
#import "secondModel.h"
#import <UIImage+GIF.h>
#import "SecondDetaileVC.h"

static NSString * const CellID = @"CellID"; 

@interface SecondHandVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) NSMutableArray *dataArr;
@property (nonatomic ,weak)   UITableView *mainTV;
@property (nonatomic ,assign) BOOL show;
@property (nonatomic ,strong) NSString *count;

@end

@implementation SecondHandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    self.count = @"20";
    [self setUI];
    [self XML:YES];

}

- (void)viewWillDisappear:(BOOL)animated {
    
    self.show = YES;
}

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)setUI {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, JLNavH, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavTab) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    [tableView setSeparatorColor:UIColorFromRGB(0xeeeeee)];
    [tableView registerNib:[UINib nibWithNibName:@"SecondCell" bundle:nil] forCellReuseIdentifier:CellID];
    tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:tableView];
    self.mainTV = tableView;
    
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadLastData)];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SecondCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"expertsTitleCell" owner:nil options:nil] firstObject];
    }
    
    secondModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    secondModel *model = self.dataArr[indexPath.row];
    SecondDetaileVC *MVC = [[SecondDetaileVC alloc] init];
    MVC.model = model;
    [self.navigationController pushViewController:MVC animated:YES];
}

- (void)loadLastData {
    [self.dataArr removeAllObjects];
    [self XML:NO];
}

#pragma mark -- XML解析
- (void)XML:(BOOL)show {
    
    if (show) {
        [self showLoding:FrameNavTab setText:@"正在加载中..."];
    }
    
    [Network postXML:@"WebServiceNew.asmx/GetTuiJianChuZuOrErShou" parameters:@{@"Count":avoidNull(self.count),@"ShuJuType":@""} success:^(id responseObj) {
        
        if (self.count.integerValue>20) {
            [_mainTV.mj_footer endRefreshingWithNoMoreData];
        }else {
            [_mainTV.mj_footer endRefreshing];
        }
        
        NSString *dataStr = responseObj[@"string"][@"text"];
        NSDictionary *dic = [XYString getObjectFromJsonString:dataStr];
        
        NSArray *dataArr = dic[@"respResult"];
        self.count = [NSString stringWithFormat:@"%@",dic[@"respCount"]];
        
        for (NSDictionary *dic2 in dataArr) {
            secondModel *model = [secondModel mj_objectWithKeyValues:dic2];
            [self.dataArr addObject:model];
        }
        [self.mainTV reloadData];
        
        [self hidenLoding];
        
    } failure:^(NSError *error) {
        [_mainTV.mj_footer endRefreshing];
        if (show) {
            [EasyEmptyView showErrorInView:self.maskView callback:^(EasyEmptyView *view, UIButton *button, callbackType callbackType) {
                [EasyEmptyView hiddenEmptyInView:self.maskView];
                [self XML:YES];
            }];
        }else {
            [EasyTextView showErrorText:@"服务器繁忙，稍后重试"];
        }
    }];
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

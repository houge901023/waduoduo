//
//  customerListVC.m
//  waduoduo
//
//  Created by Apple  on 2019/4/23.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import "customerListVC.h"
#import "customerCell.h"
#import "secondModel.h"
#import "SecondDetaileVC.h"

static NSString * const CellID = @"CellID";

@interface customerListVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) NSMutableArray *dataArr;
@property (nonatomic ,weak)   UITableView *mainTV;

@end

@implementation customerListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户列表";
    
    [self setUI];
}

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc] initWithArray:[AVUser currentUser][@"payList"]];
    }
    return _dataArr;
}

- (void)setUI {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, JLNavH, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    [tableView setSeparatorColor:UIColorFromRGB(0xeeeeee)];
    [tableView registerNib:[UINib nibWithNibName:@"customerCell" bundle:nil] forCellReuseIdentifier:CellID];
    tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:tableView];
    self.mainTV = tableView;
    
    if (self.dataArr.count == 0) {
        [EasyEmptyView showEmptyInView:self.view callback:^(EasyEmptyView *view, UIButton *button, callbackType callbackType) {
            
        }]; 
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    customerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"customerCell" owner:nil options:nil] firstObject];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *info = self.dataArr[indexPath.row];
    secondModel *model = [secondModel mj_objectWithKeyValues:info];
    cell.nameLB.text = model.Linkman;
    [cell.phoneBtn setTitle:model.Mobile forState:UIControlStateNormal];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *info = self.dataArr[indexPath.row];
    secondModel *model = [secondModel mj_objectWithKeyValues:info];
    SecondDetaileVC *MVC = [[SecondDetaileVC alloc] init];
    MVC.model = model;
    MVC.isHiden = YES;
    [self.navigationController pushViewController:MVC animated:YES];
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

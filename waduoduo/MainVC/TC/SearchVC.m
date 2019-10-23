//
//  SearchVC.m
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/14.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import "SearchVC.h"
#import "expertsListCell.h"
#import "ExpertsDetailsVC.h"

static NSString * const ExpertsListCellID = @"ExpertsListCellID";

@interface SearchVC () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.NavBar.hidden = YES;
    self.navHeight.constant = JLNavH;
    [self setYuan:self.searchView size:3];
    
    [self setUI];
}
- (NSMutableArray *)dataArr {
    if (_dataArr==nil) {
        _dataArr = [NSMutableArray array];
    }
    
    
    return _dataArr;
}
- (void)setUI {
    
    self.contentTV.estimatedRowHeight = 0;
    self.contentTV.estimatedSectionHeaderHeight = 0;
    self.contentTV.estimatedSectionFooterHeight = 0;
    [self.contentTV setSeparatorColor:UIColorFromRGB(0xeeeeee)];
    [self.contentTV registerNib:[UINib nibWithNibName:@"expertsListCell" bundle:nil] forCellReuseIdentifier:ExpertsListCellID];
    self.contentTV.tableFooterView = [[UIView alloc] init];
    if (@available(iOS 11.0, *)) {
        self.contentTV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"开始点击");
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    if (textField.text.length) {
        [self setRequest];
    }
    return YES;
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
- (void)setRequest {
    
    [self.view showLoadStateWithMaskViewStateType:viewStateWithLoading];

    [BaseRequest get:@"/searchFamous.phpx?channel=159cai&version=1" parameters:@{@"page":@(1),@"name":self.searchTF.text} success:^(id responseObj) {
        NSArray *arr = responseObj[@"Resp"][@"rows"][@"row"];
        [self.dataArr removeAllObjects];
        if (arr.count==0) {
            [self.view showLoadStateWithMaskViewStateType:viewStateWithEmpty];
        }else {
            [self.view dismessStateView];
            for (NSDictionary *dic in arr) {
                planListModel *model = [planListModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
        }
        [self.contentTV reloadData];
    } failure:^(NSError *error) {
        [self.view showLoadStateWithMaskViewStateType:viewStateWithLoadError];
    }];
}

- (IBAction)Cancel {
    [self.navigationController popViewControllerAnimated:YES];
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

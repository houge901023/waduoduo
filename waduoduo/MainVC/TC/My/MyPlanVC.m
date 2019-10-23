//
//  MyPlanVC.m
//  SouMi
//
//  Created by Apple  on 2019/4/2.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import "MyPlanVC.h"
#import "planTitleCell.h"
#import "PlanDetailsVC.h"
#import "RepairOrderVC.h"

static NSString * const PlanTitleCellID = @"PlanTitleCellID";

@interface MyPlanVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTV;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation MyPlanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的方案";
    [self.NavRight setImage:[UIImage imageNamed:@"sm_bangzhu"] forState:UIControlStateNormal];
    
    self.dataArr = [[NSMutableArray alloc] initWithArray:[AVUser currentUser][@"plan"]];
    [self.view addSubview:self.mainTV];
}

- (void)rightAction {
    RepairOrderVC *MVC = [[RepairOrderVC alloc] init];
    [self.navigationController pushViewController:MVC animated:YES];
}

- (UITableView *)mainTV {
    if (_mainTV == nil) {
        _mainTV = [[UITableView alloc] initWithFrame:CGRectMake(0, JLNavH, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH) style:UITableViewStylePlain];
        _mainTV.delegate = self;
        _mainTV.dataSource = self;
        _mainTV.showsVerticalScrollIndicator = NO;
        _mainTV.estimatedSectionHeaderHeight = 0;
        _mainTV.estimatedSectionFooterHeight = 0;
        [_mainTV setSeparatorColor:UIColorFromRGB(0xeeeeee)];
        _mainTV.estimatedRowHeight = 666;
        _mainTV.rowHeight = UITableViewAutomaticDimension;
        [_mainTV registerNib:[UINib nibWithNibName:@"planTitleCell" bundle:nil] forCellReuseIdentifier:PlanTitleCellID];
        if (@available(iOS 11.0, *)) {
            _mainTV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mainTV;
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    planTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:PlanTitleCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"planTitleCell" owner:nil options:nil] firstObject];
    }
    
    NSString *code = self.dataArr[indexPath.row];
    NSArray  *array = [code componentsSeparatedByString:@"^"];
    if (array.count>3) {
        cell.titleLB.text = array[1];
        cell.orderLB.text = [NSString stringWithFormat:@"订单：%@",array[3]];
        NSString *str = array[2];
        if (str.length==19) {
            NSString *time = [str substringWithRange:NSMakeRange(5, 11)];
            cell.timeLB.text = [NSString stringWithFormat:@"开赛时间：%@",time];
        }else {
            cell.timeLB.text = [NSString stringWithFormat:@"开赛时间：%@",str];
        }
    }

    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *code = self.dataArr[indexPath.row];
    NSArray  *array = [code componentsSeparatedByString:@"^"];
    if (array.count>3) {
        PlanDetailsVC *MVC = [[PlanDetailsVC alloc] init];
        MVC.planNo = array[0];
        MVC.history = YES;
        [self.navigationController pushViewController:MVC animated:YES];
    }
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

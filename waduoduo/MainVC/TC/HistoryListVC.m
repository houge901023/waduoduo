//
//  HistoryListVC.m
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/16.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import "HistoryListVC.h"
#import "planTitleCell.h"
#import "planDetailsModel.h"
#import "PlanDetailsVC.h"

static NSString * const PlanTitleCellID = @"PlanTitleCellID";

@interface HistoryListVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) planDetailsModel *model;
@property (nonatomic, strong) NSDictionary *lotteryTypeMap;

@end

@implementation HistoryListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.NavBar.hidden = YES;
    self.mainTV.stateView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH-48);

    [self setRequest];
}
- (NSDictionary *)lotteryTypeMap {
    if (_lotteryTypeMap==nil) {
        _lotteryTypeMap = @{@"1":@"竞彩足球", @"2":@"竞彩篮球", @"3":@"胜负彩", @"4":@"任选九"};
    }
    return _lotteryTypeMap;
}
- (UITableView *)mainTV {
    if (_mainTV == nil) {
        _mainTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH-40) style:UITableViewStylePlain];
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
    return self.model.explanlists.count;
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
    NotStartList *model = [NotStartList mj_objectWithKeyValues:self.model.explanlists[indexPath.row]];
    cell.titleLB.text = model.plantitle;
    if (model.begintime.length==19) {
        NSString *time = [model.begintime substringWithRange:NSMakeRange(5, 11)];
        cell.timeLB.text = [NSString stringWithFormat:@"开赛时间：%@",time];
    }else {
        cell.timeLB.text = [NSString stringWithFormat:@"开赛时间：%@",model.begintime];
    }
    cell.typeLB.text = self.lotteryTypeMap[model.lotterytype];
    cell.typeLB.hidden = NO;
    cell.typeWidth.constant = [cell.typeLB.text widthWithFont:11 h:15]+8;
    cell.typeLB.layer.cornerRadius = 15/2;
    UIColor *typeColor;
    if ([cell.typeLB.text isEqualToString:@"竞彩足球"]) {
        typeColor = COLOR_MAIN;
    }else if ([cell.typeLB.text isEqualToString:@"竞彩篮球"]) {
        typeColor = UIColorFromRGB(0xBC8F8F);
    }else if ([cell.typeLB.text isEqualToString:@"胜负彩"]) {
        typeColor = UIColorFromRGB(0xFFD700);
    }else if ([cell.typeLB.text isEqualToString:@"任选九"]) {
        typeColor = UIColorFromRGB(0xE3A869);
    }else {
        cell.typeLB.hidden = YES;
    }
    cell.typeLB.layer.borderColor = typeColor.CGColor;
    cell.typeLB.layer.borderWidth = SCALELINEH;
    cell.typeLB.textColor = typeColor;
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NotStartList *model = [NotStartList mj_objectWithKeyValues:self.model.explanlists[indexPath.row]];
    PlanDetailsVC *MVC = [[PlanDetailsVC alloc] init];
    MVC.planNo = model.cprojid;
    MVC.history = YES;
    [self.navigationController pushViewController:MVC animated:YES];
}
- (void)setRequest {
    
    [self.mainTV showLoadStateWithMaskViewStateType:viewStateWithLoading];
    [BaseRequest get:@"/getFamousExplainList.php" parameters:@{@"author":self.ExpertsNo, @"type":self.type} success:^(id responseObj) {
        
        NSDictionary *dic = responseObj[@"data"];
        self.model = [planDetailsModel mj_objectWithKeyValues:dic];
        if (self.model.explanlists.count==0) {
            [self.mainTV showLoadStateWithMaskViewStateType:viewStateWithEmpty];
        }else {
            [self.mainTV dismessStateView];
        }
        [self.mainTV reloadData];
    } failure:^(NSError *error) {
        [self.mainTV showLoadStateWithMaskViewStateType:viewStateWithLoadError];
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

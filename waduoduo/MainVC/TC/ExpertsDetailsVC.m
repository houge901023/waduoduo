//
//  ExpertsDetailsVC.m
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/14.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import "ExpertsDetailsVC.h"
#import "planDetailsModel.h"
#import "planHeadCell.h"
#import "planTitleCell.h"
#import "PlanDetailsVC.h"
#import "HistoryVC.h"

static NSString * const PlanHeadCellID = @"PlanHeadCellID";
static NSString * const PlanTitleCellID = @"PlanTitleCellID";

@interface ExpertsDetailsVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *mainTV;
@property (nonatomic, strong) planDetailsModel *model;
@property (nonatomic, strong) NSDictionary *lotteryTypeMap;

@end

@implementation ExpertsDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专家详情";
    self.titleLB.frame = CGRectMake(100, JLNavY(20), SCREEN_WIDTH-200, 44);
    self.NavRight.frame = CGRectMake(SCREEN_WIDTH-95, JLNavY(20), 90, 44);
    [self.NavRight setTitle:@"历史数据" forState:UIControlStateNormal];
    
    [self setUI];
    [self setRequest];
}
- (NSDictionary *)lotteryTypeMap {
    if (_lotteryTypeMap==nil) {
        _lotteryTypeMap = @{@"1":@"竞彩足球", @"2":@"竞彩篮球", @"3":@"胜负彩", @"4":@"任选九"};
    }
    return _lotteryTypeMap;
}
- (void)rightAction {
    
    HistoryVC *MVC = [[HistoryVC alloc] init];
    MVC.ExpertsNo = self.model.cauthorid;
    MVC.name = self.model.authName;
    [self.navigationController pushViewController:MVC animated:YES];
}
- (void)setUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, JLNavH, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    [tableView setSeparatorColor:UIColorFromRGB(0xeeeeee)];
    [tableView registerNib:[UINib nibWithNibName:@"planHeadCell" bundle:nil] forCellReuseIdentifier:PlanHeadCellID];
    [tableView registerNib:[UINib nibWithNibName:@"planTitleCell" bundle:nil] forCellReuseIdentifier:PlanTitleCellID];
    [self.view addSubview:tableView];
    tableView.estimatedRowHeight = 666;
    tableView.rowHeight = UITableViewAutomaticDimension;
    if (@available(iOS 11.0, *)) {
        _mainTV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.mainTV = tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==1) {
        return self.model.explanlists.count;
    }else {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==0) {
        return 8;
    }else {
        return CGFLOAT_MIN;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        planHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:PlanHeadCellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"planHeadCell" owner:nil options:nil] firstObject];
        }
        cell.model = self.model;
//        CGFloat b = self.model.hitnum.floatValue/self.model.allnum.floatValue;
//        if (b>0.7) {
//            cell.zhongLB.hidden = NO;
//            cell.zhongLB.text = @" 超级盈利 ";
//        }else if(b<=0.7 && b>0.5){
//            cell.zhongLB.hidden = NO;
//            cell.zhongLB.text = @" 状态火热 ";
//        }else {
//            cell.zhongLB.hidden = YES;
//        }
        return cell;
    }else {
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
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        NotStartList *model = [NotStartList mj_objectWithKeyValues:self.model.explanlists[indexPath.row]];
        PlanDetailsVC *MVC = [[PlanDetailsVC alloc] init];
        MVC.planNo = model.cprojid;
        MVC.type = model.lotterytype;
        [self.navigationController pushViewController:MVC animated:YES];
    }
}
- (void)setRequest {
    
    [self.view showLoadStateWithMaskViewStateType:viewStateWithLoading];
    [BaseRequest get:@"/getFamousExplainList.phpx?channel=159cai&version=1" parameters:@{@"name":self.ExpertsNo, @"type":@"1"} success:^(id responseObj) {
        [self.view dismessStateView];
        NSDictionary *dic = responseObj[@"Resp"][@"rows"][@"row"];
        self.model = [planDetailsModel mj_objectWithKeyValues:dic];
        [self.mainTV reloadData];
    } failure:^(NSError *error) {
        [self.view showLoadStateWithMaskViewStateType:viewStateWithLoadError];
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

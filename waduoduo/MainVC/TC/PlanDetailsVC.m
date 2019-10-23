//
//  PlanDetailsVC.m
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/12.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import "PlanDetailsVC.h"
#import "planHeadCell.h"
#import "planTitleCell.h"
#import "gameCell.h"
#import "planContentcell.h"
#import "planTitleCell.h"
#import "planDetailsModel.h"
#import "HistoryVC.h"
#import "HZIAPManager.h"
#import "problemVC.h"
#import "LoginVC.h"
#import "NSDate+Utils.h"
#import "MainNavigationController.h"
#import "infomoreVC.h"

static NSString * const PlanHeadCellID = @"PlanHeadCellID";
static NSString * const PlanTitleCellID = @"PlanTitleCellID";
static NSString * const GameCellID = @"GameCellID";
static NSString * const PlanContentCellID = @"PlanContentCellID";

@interface PlanDetailsVC () <UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>

@property (nonatomic, weak) UITableView *mainTV;
@property (nonatomic, strong) planDetailsModel *model;
@property (nonatomic, strong) NSDictionary *lotteryTypeMap;
@property (nonatomic, strong) UIWebView *webTest;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation PlanDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"方案详情";
    self.titleLB.frame = CGRectMake(100, JLNavY(20), SCREEN_WIDTH-200, 44);
    self.NavRight.frame = CGRectMake(SCREEN_WIDTH-95, JLNavY(20), 90, 44);
    [self.NavRight setTitle:@"历史数据" forState:UIControlStateNormal];
    
    [self setUI];
    [self setRequest];
}
- (void)rightAction {
    
    HistoryVC *MVC = [[HistoryVC alloc] init];
    MVC.ExpertsNo = self.model.authName;
    MVC.name = self.model.authName;
    [self.navigationController pushViewController:MVC animated:YES];
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        NSLog(@"成功保存到相册");
    }else
    {
        NSLog(@"系统设置没有开启");
    }
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
    [tableView registerNib:[UINib nibWithNibName:@"gameCell" bundle:nil] forCellReuseIdentifier:GameCellID];
    [tableView registerNib:[UINib nibWithNibName:@"planContentcell" bundle:nil] forCellReuseIdentifier:PlanContentCellID];
    [self.view addSubview:tableView];
    tableView.estimatedRowHeight = 666;
    tableView.rowHeight = UITableViewAutomaticDimension;
    self.mainTV = tableView;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    self.dataArr = [[NSMutableArray alloc] initWithArray:[AVUser currentUser][@"plan"]];
    
}
- (UIWebView *)webTest {
    if (_webTest==nil) {
        _webTest = [[UIWebView alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT+10, SCREEN_WIDTH-20, 20)];
        _webTest.delegate = self;
        [self.view addSubview:_webTest];
    }
    return _webTest;
}
- (UIView *)footView {
    if (_footView == nil) {
        _footView = [[UIView alloc] init];
        _footView.backgroundColor = [UIColor whiteColor];
    }
    return _footView;
}
- (UIWebView *)webView {
    if (_webView==nil) {
        _webView = [[UIWebView alloc] init];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.bounces = NO;
        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
        [_webView sizeToFit];

    }
    return _webView;
}
- (NSDictionary *)lotteryTypeMap {
    if (_lotteryTypeMap==nil) {
        _lotteryTypeMap = @{@"1":@"竞彩足球", @"2":@"竞彩篮球", @"3":@"胜负彩", @"4":@"任选九"};
    }
    return _lotteryTypeMap;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.history) {
        return 3;
    }else {
        return 4;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==2) {
        return self.model.planforecastitems.count;
    }else {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==0||section==2) {
        return 8;
    }else {
        return CGFLOAT_MIN;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==2) {
        return 90;
    }else {
        return UITableViewAutomaticDimension;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        planHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:PlanHeadCellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"planHeadCell" owner:nil options:nil] firstObject];
        }
        cell.model = self.model;
        return cell;
    }else if (indexPath.section==1){
        planTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:PlanTitleCellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"planTitleCell" owner:nil options:nil] firstObject];
        }
        cell.titleLB.text = self.model.plantitle;
        if (self.model.releaseTime.length==19) {
            NSString *time = [self.model.releaseTime substringWithRange:NSMakeRange(5, 11)];
            cell.timeLB.text = [NSString stringWithFormat:@"发布时间：%@",time];
        }else {
            cell.timeLB.text = [NSString stringWithFormat:@"发布时间：%@",self.model.releaseTime];
        }
        cell.typeLB.text = self.lotteryTypeMap[self.model.lotterytype];
        cell.typeLB.hidden = NO;
        cell.typeWidth.constant = [cell.typeLB.text widthWithFont:11 h:15]+8;
        cell.typeLB.layer.cornerRadius = 15/2;
        cell.typeLB.clipsToBounds = YES;
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
        
        if (self.history) {
            cell.typeLB.hidden = YES;
        }
        
        cell.typeLB.backgroundColor = typeColor;
        
        return cell;
    }else if (indexPath.section==2){
        gameCell *cell = [tableView dequeueReusableCellWithIdentifier:GameCellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"gameCell" owner:nil options:nil] firstObject];
        }
        planTeamList *model = [planTeamList mj_objectWithKeyValues:self.model.planforecastitems[indexPath.row]];
        cell.model = model;
        return cell;
    }else {
        planContentcell *cell = [tableView dequeueReusableCellWithIdentifier:PlanContentCellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"planContentcell" owner:nil options:nil] lastObject];
        }
        cell.contextLB.text = self.model.plansummary;
        if ([self.model.lotterytype isEqualToString:@"3"]) {
            cell.iconImg.image = [UIImage imageNamed:@"goods1"];
        }else if ([self.model.lotterytype isEqualToString:@"4"]) {
            cell.iconImg.image = [UIImage imageNamed:@"goods2"];
        }else {
            cell.iconImg.image = [UIImage imageNamed:@"goods3"];
        }
        return cell;
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"gaodu=%.2f",webView.scrollView.contentSize.height);
    self.webView.frame = CGRectMake(10, 10, SCREEN_WIDTH-20, webView.scrollView.contentSize.height);
    self.footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, webView.scrollView.contentSize.height+30);
    [self.footView addSubview:self.webView];
    self.mainTV.tableFooterView = self.footView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==3) {
        infomoreVC *MVC = [[infomoreVC alloc] init];
        if ([self.model.lotterytype isEqualToString:@"3"]) {
            MVC.price = @"88";
        }else if ([self.model.lotterytype isEqualToString:@"4"]) {
            MVC.price = @"78";
        }else {
            MVC.price = @"38";
        }
        [self.navigationController pushViewController:MVC animated:YES];
    }
}
- (void)setRequest {
    
    [self.view showLoadStateWithMaskViewStateType:viewStateWithLoading];
    // 方案详情
    [BaseRequest getAll:[NSString stringWithFormat:@"http://www.159cai.com/phpu/getFamousExplainBydbno.phpx?channel=159cai&planNo=%@",self.planNo] parameters:nil success:^(id responseObj) {
        
        [self.view dismessStateView];
        NSDictionary *dic = responseObj[@"Resp"][@"rows"][@"row"];
        self.model = [planDetailsModel mj_objectWithKeyValues:dic];
        if (self.type.length>0) {
            self.model.lotterytype = self.type;
        }
        [self.mainTV reloadData];
//        if (self.history) {
//            [self.webTest loadHTMLString:self.model.plandescription baseURL:nil];
//            [self.webView loadHTMLString:self.model.plandescription baseURL:nil];
//        }
        [self.webTest loadHTMLString:self.model.plandescription baseURL:nil];
        [self.webView loadHTMLString:self.model.plandescription baseURL:nil];
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

//
//  SecondDetaileVC.m
//  waduoduo
//
//  Created by Apple  on 2019/4/22.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import "SecondDetaileVC.h"
#import "SecondCell2.h"
#import "HZIAPManager.h"
#import "payInfoVC.h"

static NSString * const CellID = @"CellID"; 

@interface SecondDetaileVC () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Top;
@property (weak, nonatomic) IBOutlet UIImageView *headImageV;
@property (weak, nonatomic) IBOutlet UITableView *mainTV;
@property (nonatomic ,strong) NSArray *titleArr;
@property (nonatomic ,strong) NSArray *contentArr;
@property (nonatomic ,strong) NSMutableArray *payArr;

@property (nonatomic ,strong) UIView *backView;

@end

@implementation SecondDetaileVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"设备详情";
    if (self.isHiden == NO && self.model.Mobile.length == 11) {
        [self configureRight:@"联系机主"];
    }
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.backView.backgroundColor = UIColorWithRGBA(0, 0, 0, 0.3);
    self.backView.hidden = YES;
    [APP_DELE.window addSubview:self.backView];
    
    [self setUI];
}

- (void)rightNavAction {
    
    if ([AVUser currentUser]==nil) {
        [EasyTextView showInfoText:@"请先登录"];
        return;
    }
    
    self.backView.hidden = NO;
    [EasyLoadingView showLoadingImage:@"正在获取中..."];
    [[HZIAPManager shareIAPManager] startIAPWithProductID:@"200010" completeHandle:^(IAPResultType type, NSData * _Nonnull data) {
        if (type == IAPResultVerSuccess || type == IAPResultSuccess) {

            if (self.payArr.count == 0) {
                [self.payArr addObject:[[self.model mj_keyValues] jsonStr]];
            }else {
                [self.payArr insertObject:[[self.model mj_keyValues] jsonStr] atIndex:0];
            }
            [self updatePay];
        }else {
            self.backView.hidden = YES;
        }
    }];
}

- (void)setUI {
    
    self.Top.constant = JLNavH;
    [self.headImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IP,[self.model.PhotoPath substringFromIndex:3]]] placeholderImage:[UIImage imageNamed:@"wdd_placeholder"]];
    
    self.titleArr = @[@"",@"品牌：",@"型号：",@"购买年份：",@"工作时间：",@"发布时间：",@"联系人：",@"联系地址："];
    self.contentArr = @[self.model.StkTitle,self.model.BrandName,self.model.Spec,self.model.Years,self.model.sHour,[self setString:self.model.LastDate],self.model.Linkman,self.model.SAddress];
    
    self.mainTV.delegate = self;
    self.mainTV.dataSource = self;
    self.mainTV.estimatedRowHeight = 46;
    self.mainTV.estimatedSectionHeaderHeight = 0;
    self.mainTV.estimatedSectionFooterHeight = 0;
    self.mainTV.rowHeight = UITableViewAutomaticDimension;
    [self.mainTV setSeparatorColor:UIColorFromRGB(0xeeeeee)];
    [self.mainTV registerNib:[UINib nibWithNibName:@"SecondCell2" bundle:nil] forCellReuseIdentifier:CellID];
    self.mainTV.tableFooterView = [[UIView alloc] init];
    
    NSLog(@"自定 = %@。 惊悚=%@",[self.model mj_keyValues] ,[[self.model mj_keyValues] jsonStr]);
    
    self.payArr = [[NSMutableArray alloc] initWithArray:[AVUser currentUser][@"payList"]];

}

- (void)updatePay {
    
    AVUser *user = [AVUser currentUser];
    [user setObject:self.payArr forKey:@"payList"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        self.backView.hidden = YES;
        [EasyLoadingView hidenLoading];
        if (succeeded) {
            payInfoVC *MVC = [[payInfoVC alloc] init];
            MVC.isSuccess = 1;
            MVC.tel = self.model.Mobile;
            [self.navigationController pushViewController:MVC animated:YES];
        }else {
            payInfoVC *MVC = [[payInfoVC alloc] init];
            MVC.isSuccess = 2;
            MVC.tel = self.model.Mobile;
            [self.navigationController pushViewController:MVC animated:YES];
        }
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArr.count;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 46;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SecondCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"expertsTitleCell" owner:nil options:nil] firstObject];
    }

    cell.titleLB.text = self.titleArr[indexPath.row];
    cell.contentLB.text = self.contentArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSString *)setString:(NSString *)string {
    return [[string substringToIndex:string.length-3] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
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

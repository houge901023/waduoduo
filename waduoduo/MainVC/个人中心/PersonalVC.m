//
//  PersonalVC.m
//  waduoduo
//
//  Created by 名侯 on 2017/4/20.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import "PersonalVC.h"
#import "settingVC.h"
#import "LoginVC.h"
#import "SupplyVC.h"
#import "MycollecVC.h"
#import "feedbackVC.h"
#import "PrivacyVC.h"
#import "versonVC.h"
#import "ViewControllerPDF.h"
#import "customerListVC.h"

@interface PersonalVC () <UITableViewDelegate,UITableViewDataSource>
{
    UILabel *nameLB;
    UIImageView *icon;
}

@property (nonatomic ,strong) NSArray *titleArr;

@end

@implementation PersonalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.hidden = YES;
    [self setup];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AVUser *user = [AVUser currentUser];
    if (user||APP_DELE.refreshNum==2) {
        
        APP_DELE.refreshNum = 0;
        
        nameLB.text = user.username;
        [icon sd_setImageWithURL:[NSURL URLWithString:[user[@"iconHead"] imgUrlUpdate]] placeholderImage:[UIImage imageNamed:@"my_icon"]];
    }else {
        nameLB.text = @"点击登录";
        [icon setImage:[UIImage imageNamed:@"my_icon"]];
    }

}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (NSArray *)titleArr {
    if (_titleArr==nil) {
        
        _titleArr = [[NSMutableArray alloc] initWithObjects:@[@"我的供求",@"我的收藏",@"我的客户"],@[@"意见反馈",@"隐私政策",@"关于我们"],@[@"体彩攻略"], nil];
    }
    return _titleArr;
}

- (void)setup {
    
    UITableView *mainTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49) style:UITableViewStyleGrouped];
    mainTV.delegate = self;
    mainTV.dataSource = self;
    mainTV.bounces = NO;
    mainTV.estimatedSectionHeaderHeight = 0;
    mainTV.estimatedSectionFooterHeight = 0;
    mainTV.estimatedRowHeight = 0;
    [self.view addSubview:mainTV];
    
    if (@available(iOS 11.0, *)) {
        mainTV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    //head
    UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHeight(160))];
    headV.backgroundColor = mainBlue;
    mainTV.tableHeaderView = headV;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginAction)];
    [headV addGestureRecognizer:tap];
    
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(40, kHeight(50), kHeight(60), kHeight(60))];
    [icon sd_setImageWithURL:[NSURL URLWithString:[[AVUser currentUser][@"iconHead"] imgUrlUpdate]] placeholderImage:[UIImage imageNamed:@"my_icon"]];
    icon.contentMode = UIViewContentModeScaleAspectFill;
    icon.layer.masksToBounds = YES;
    [self setYuan:icon size:kHeight(30)];
    [self setBorder:icon size:2 withColor:[UIColor whiteColor]];
    [headV addSubview:icon];
    
    nameLB = [[UILabel alloc] initWithFrame:CGRectMake(kVIEW_BX(icon)+15, 0, SCREEN_WIDTH-80-kHeight(60), 20)];
    nameLB.textColor = [UIColor whiteColor];
    nameLB.font = kFONT(16);
    nameLB.centerY = icon.centerY;
    [headV addSubview:nameLB];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.titleArr[section];
    return arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0&&indexPath.row==0) {
        [LoginVC LoginSuccess:^{
            SupplyVC *MVC = [[SupplyVC alloc] init];
            MVC.userId = [AVUser currentUser].objectId;
            MVC.Personal = YES;
            [self.navigationController pushViewController:MVC animated:YES];
        }];
        
    }else if (indexPath.section==0&&indexPath.row==1) {

        [LoginVC LoginSuccess:^{
            MycollecVC *MVC = [[MycollecVC alloc] init];
            [self.navigationController pushViewController:MVC animated:YES];
        }];
        
    }else if (indexPath.section==0&&indexPath.row==2) {
        [LoginVC LoginSuccess:^{
            customerListVC *MVC = [[customerListVC alloc] init];
            [self.navigationController pushViewController:MVC animated:YES];
        }];
    }else if (indexPath.section==1&&indexPath.row==0) {
        [LoginVC LoginSuccess:^{
            feedbackVC *MVC = [[feedbackVC alloc] init];
            [self.navigationController pushViewController:MVC animated:YES];
        }];
    }else if (indexPath.section==1&&indexPath.row==1) {
        PrivacyVC *MVC = [[PrivacyVC alloc] init];
        [self.navigationController pushViewController:MVC animated:YES];
    }else if (indexPath.section==1&&indexPath.row==2) {
        versonVC *MVC = [[versonVC alloc] init];
        [self.navigationController pushViewController:MVC animated:YES];
    }else if (indexPath.section==2) {
        //你的客服号码。
        NSString  *qqNumber=@"2280246875";
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
            NSURL * url=[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qqNumber]];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            webView.delegate = self;
            [webView loadRequest:request];
            [self.view addSubview:webView];
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"对不起，您还没安装QQ" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                return ;
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    cell.imageView.image = [UIImage imageNamed:@[@[@"supply_1",@"collection",@"shebei"],@[@"opinion",@"my_ys",@"version"],@[@"sm_gzed"]][indexPath.section][indexPath.row]];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = titleC1;
    cell.textLabel.text = self.titleArr[indexPath.section][indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)loginAction {
    if ([AVUser currentUser]) {
        settingVC *MVC = [[settingVC alloc] init];
        [self.navigationController pushViewController:MVC animated:YES];
    }else {
        LoginVC *MVC = [[LoginVC alloc] init];
        MainNavigationController *NAV = [[MainNavigationController alloc] initWithRootViewController:MVC];
        [self presentViewController:NAV animated:YES completion:nil];
    }
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

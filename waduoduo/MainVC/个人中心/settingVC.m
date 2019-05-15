//
//  settingVC.m
//  waduoduo
//
//  Created by 名侯 on 2017/4/20.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import "settingVC.h"
#import "LoginVC.h"
#import "setCell.h"
#import "EditdataVC.h"
#import "LQPopUpView.h"
#import <RongIMKit/RongIMKit.h>

@interface settingVC () <UITableViewDelegate,UITableViewDataSource>
{
    CGFloat cellH;
    NSString *clearCacheName;
}
@property (nonatomic ,strong) UITableView *mainTV;
@property (nonatomic ,strong) NSMutableArray *titleArr;

@end

@implementation settingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    [self configureRight:@"编辑"];
    
    [self setup];
}

- (void)setup {
    
    _mainTV = [[UITableView alloc] initWithFrame:CGRectMake(0, JLNavH, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH) style:UITableViewStyleGrouped];
    _mainTV.delegate = self;
    _mainTV.dataSource = self;
    _mainTV.estimatedRowHeight = 0;
    _mainTV.estimatedSectionHeaderHeight = 0;
    _mainTV.estimatedSectionFooterHeight = 0;
    [self.view addSubview:_mainTV];
    
    float tmpSize = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
    float tol = tmpSize;
    clearCacheName = tol >= 1 ? [NSString stringWithFormat:@"%.2fM",tol] : [NSString stringWithFormat:@"%.2fK",tol * 1024];
    NSLog(@"%@",clearCacheName);
}

- (NSMutableArray *)titleArr {
    if (_titleArr==nil) {
        _titleArr = [[NSMutableArray alloc] initWithObjects:@[@""],@[@"手机号",@"ID",@"公司",@"职业",@"挖机型号",@"所在地",@"个人简介"],@[@"清理缓存"],@[@"退出登录"], nil];
    }
    return _titleArr;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.titleArr[section];
    return arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 60;
    }else {
        if (cellH>44 && indexPath.section==1) {
            return cellH;
        }else {
             return 44;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==3) {
        return 40;
    }else {
        return CGFLOAT_MIN;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==2) {
        
        [AVQuery clearAllCachedResults];
        [AVFile clearAllPersistentCache];
        [self clearTmpPics];
        [tableView reloadData];
        [EasyTextView showSuccessText:@"清理成功"];
    }else if (indexPath.section==3) {
        
        LQPopUpView *popUpView = [[LQPopUpView alloc] initWithTitle:@"提示" message:@"是否确定退出登录"];
        
        [popUpView addBtnWithTitle:@"取消" type:LQPopUpBtnStyleCancel handler:^{
            // do something...
        }];
        
        [popUpView addBtnWithTitle:@"确定" type:LQPopUpBtnStyleDefault handler:^{
            [AVUser logOut];
            [[RCIM sharedRCIM] logout];
            
            LoginVC *MVC = [[LoginVC alloc] init];
            MainNavigationController *NAV = [[MainNavigationController alloc] initWithRootViewController:MVC];
            [self presentViewController:NAV animated:YES completion:nil];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        
        [popUpView showInView:self.view preferredStyle:LQPopUpViewStyleAlert];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    setCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[setCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    NSString *tiStr = self.titleArr[indexPath.section][indexPath.row];
    AVUser *user = [AVUser currentUser];
    
    if ([tiStr isEqualToString:@""]) {
        cell.titleLB.hidden = YES;
        cell.iconImg.hidden = NO;
        [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:avoidNull([user[@"iconHead"] imgUrlUpdate])] placeholderImage:[UIImage imageNamed:@"my_icon"]];
        cell.iconImg.contentMode = UIViewContentModeScaleAspectFill;
        cell.iconImg.layer.masksToBounds = YES;
        cell.valueLB.centerY = 30;
    }else if ([tiStr isEqualToString:@"清理缓存"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.valueLB.width = SCREEN_WIDTH-135;
    }else if ([tiStr isEqualToString:@"退出登录"]) {
        cell.titleLB.textAlignment = NSTextAlignmentCenter;
        cell.titleLB.font = [UIFont systemFontOfSize:16];
        cell.titleLB.centerX = SCREEN_WIDTH/2;
    }else if ([tiStr isEqualToString:@"个人简介"]) {
        CGFloat H = [XYString HeightForText:avoidNull(user[@"userinfo"]) withSizeOfLabelFont:15 withWidthOfContent:SCREEN_WIDTH-115];
        NSLog(@"cell高度=%.2f",H);
        if (H>20) {
            cell.valueLB.textAlignment = NSTextAlignmentLeft;
            cell.valueLB.numberOfLines = 0;
            cell.valueLB.height = H;
            [cell sizeToFit];
        }else {
            cell.valueLB.textAlignment = NSTextAlignmentRight;
        }
        cellH = H+24;
    }
    
    cell.titleLB.text = tiStr;
    
    NSArray *valueArr = @[@[avoidNull(user.username)],
                       @[user.mobilePhoneNumber,user.objectId,avoidNull(user[@"company"]),avoidNull(user[@"usertype"]),
                         avoidNull(user[@"model"]),avoidNull(user[@"usercity"]),avoidNull(user[@"userinfo"])],
                       @[clearCacheName],
                       @[@""]];
    
    cell.valueLB.text = valueArr[indexPath.section][indexPath.row];
    if (indexPath.section!=2&&indexPath.section!=3) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)rightNavAction {

    EditdataVC *MVC = [[EditdataVC alloc] init];
    [self.navigationController pushViewController:MVC animated:YES];
}

#pragma mark -- 清理缓存图片
- (void)clearTmpPics{
    
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
    
    float tmpSize = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
    NSLog(@"%lf",tmpSize);
    clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM",tmpSize] : [NSString stringWithFormat:@"%.2fK",tmpSize * 1024];
    NSLog(@"%@",clearCacheName);
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

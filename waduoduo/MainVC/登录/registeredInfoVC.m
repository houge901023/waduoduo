//
//  registeredInfoVC.m
//  waduoduo
//
//  Created by 名侯 on 2017/4/24.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import "registeredInfoVC.h"
#import "WTTextView.h"
#import "TWSelectCityView.h"

@interface registeredInfoVC ()
{
    UITextField *companyTF;
    UITextField *typeTF;
    WTTextView *textV;
}
@end

@implementation registeredInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完善信息";
    self.navBarView.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setup];
}

- (void)setup {
    
    NSString *title;
    NSString *info;
    if ([_type isEqualToString:@"1"]) {
        title = @"挖机型号";
        info = @"";
    }else {
        title = @"公司名称";
        info = @"填写公司名称，发布信息时可以提升自己的信任度（填写后不可修改，谨慎填写）";
    }
    
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(15, 80, SCREEN_WIDTH-30, 45)];
    [self setYuan:backV size:5];
    [self setBorder:backV size:1];
    [self.view addSubview:backV];
    
    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 70, 45)];
    titleLB.font = [UIFont systemFontOfSize:15];
    titleLB.textColor = titleC1;
    [backV addSubview:titleLB];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@*",title]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, 1)];
    titleLB.attributedText = str;
    
    companyTF = [[UITextField alloc] initWithFrame:CGRectMake(95, 5, SCREEN_WIDTH-140, 35)];
    companyTF.placeholder = [NSString stringWithFormat:@"请输入%@",title];
    companyTF.textColor = titleC1;
    companyTF.font = [UIFont systemFontOfSize:14];
    [backV addSubview:companyTF];
    
    if (![XYString isObjectNull:info]) {
        UILabel *infoLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 55, SCREEN_WIDTH-60, 10)];
        infoLB.text = info;
        infoLB.font = [UIFont systemFontOfSize:11];
        infoLB.textColor = titleC2;
        infoLB.numberOfLines = 0;
        [infoLB sizeToFit];
        [backV addSubview:infoLB];
        
        [self PixeH:CGPointMake(0, 44) lenght:SCREEN_WIDTH-30 add:backV];
        backV.height = kVIEW_BY(infoLB)+10;
    }
    
    [self setCity:backV];
}

- (void)setCity:(UIView *)view {
    
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(15, kVIEW_BY(view)+20, SCREEN_WIDTH-30, 45)];
    [self setYuan:backV size:5];
    [self setBorder:backV size:1];
    [self.view addSubview:backV];
    
    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 70, 45)];
    titleLB.font = [UIFont systemFontOfSize:15];
    titleLB.textColor = titleC1;
    [backV addSubview:titleLB];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"所在地*"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, 1)];
    titleLB.attributedText = str;
    
    typeTF = [[UITextField alloc] initWithFrame:CGRectMake(85, 5, SCREEN_WIDTH-160, 35)];
    typeTF.placeholder = @"请选择省／市";
    typeTF.textColor = titleC1;
    typeTF.font = [UIFont systemFontOfSize:14];
    [backV addSubview:typeTF];
    
    UIButton *Click = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 5, 35, 35)];
    [Click setImage:[UIImage imageNamed:@"icon_login_Click"] forState:UIControlStateNormal];
    [backV addSubview:Click];
    
    UIButton *role = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 45)];
    [role addTarget:self action:@selector(roleAction) forControlEvents:UIControlEventTouchUpInside];
    [backV addSubview:role];
    
    textV = [[WTTextView alloc] initWithFrame:CGRectMake(15, kVIEW_BY(backV)+20, SCREEN_WIDTH-30, kHeight(150))];
    textV.placeHolder = @"简单介绍下...";
    textV.font = [UIFont systemFontOfSize:14];
    textV.textColor = titleC1;
    [self setYuan:textV size:5];
    [self setBorder:textV size:1];
    [self.view addSubview:textV];
    
    UIButton *mainBT = [self setbutton:@"确定" setY:kVIEW_BY(textV)+kHeight(40) add:self.view];
    mainBT.height = 45;
    mainBT.titleLabel.font = [UIFont systemFontOfSize:18];
}

- (void)roleAction {
    TWSelectCityView *city = [[TWSelectCityView alloc] initWithTWFrame:self.view.bounds TWselectCityTitle:@"选择地区"];
//    __weak typeof(self)blockself = self;
    [city showCityView:^(NSString *proviceStr, NSString *cityStr, NSString *distr) {
        typeTF.text = [NSString stringWithFormat:@"%@%@%@",proviceStr,cityStr,distr];
        NSLog(@"%@",[NSString stringWithFormat:@"%@->%@->%@",proviceStr,cityStr,distr]);
    }];
}

- (void)mainAction {
    
    if (companyTF.text.length==0) {
        if ([_type isEqualToString:@"2"]) {
            [EasyTextView showText:@"公司不能为空"];
        }else {
            [EasyTextView showText:@"挖机机型不能为空"];
        }
    }else if (typeTF.text.length==0) {
        [EasyTextView showText:@"所在地不能为空"];
    }else {
        [self request];
    }
}

#pragma mark -- 注册的网络请求
- (void)request {
    
    [EasyLoadingView showLoadingImage:@"正在加载中..."];
    [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:_phone smsCode:_Verification block:^(AVUser * _Nullable user, NSError * _Nullable error) {
        if (!error) {
            
            user.username = _phone;
            user.password = _pass;

            [user setObject:avoidNull(textV.text) forKey:@"User_info"];
            [user setObject:avoidNull(typeTF.text) forKey:@"User_city"];
            [user setObject:@"1" forKey:@"Power"];
            if ([_type isEqualToString:@"2"]) {
                [user setObject:avoidNull(companyTF.text) forKey:@"Company"];
            }else {
                [user setObject:avoidNull(companyTF.text) forKey:@"Wmodels"];
            }
            
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"注册成功");
                    /*
                     createdAt = "2016-12-06T06:52:19.140Z";
                     emailVerified = 0;
                     mobilePhoneVerified = 0;
                     objectId = 584660232f301e005c186431;
                     sessionToken = ogbpdzvdbk9hnkvgqqmdzooi6;
                     updatedAt = "2016-12-06T06:52:19.140Z";
                     username = 15281047296;
                     */
                    NSLog(@"用户＝%@",user);
                    [EasyTextView showSuccessText:@"注册成功"];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    NSString *msg = [NSString stringWithFormat:@"错误码：%ld",error.code];
                    if ([XYString isObjectNull:msg]) {
                        [EasyTextView showErrorText:@"注册失败"];
                    }else {
                        [EasyTextView showErrorText:msg];
                    }
                }
            }];
        }else {
            NSString *msg = [NSString stringWithFormat:@"错误码：%ld",error.code];
            if ([XYString isObjectNull:msg]) {
                [EasyTextView showErrorText:@"注册失败"];
            }else {
                [EasyTextView showErrorText:msg];
            }
        }
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

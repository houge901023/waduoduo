//
//  ForgotpassVC.m
//  waduoduo
//
//  Created by 名侯 on 2017/4/25.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import "ForgotpassVC.h"
#import "UIButton+WT.h"

@interface ForgotpassVC ()
{
    UITextField *phoneTF;
    UITextField *VerificationTF;
    UITextField *passTF;
}
@end

@implementation ForgotpassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    self.navBarView.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setup];
}

- (void)setup {
    
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(15, 80, SCREEN_WIDTH-30, 135)];
    [self setYuan:backV size:5];
    [self setBorder:backV size:1];
    [self.view addSubview:backV];
    
    [self PixeH:CGPointMake(0, 44) lenght:SCREEN_WIDTH-30 add:backV];
    [self PixeH:CGPointMake(0, 89) lenght:SCREEN_WIDTH-30 add:backV];
    
    for (int i=0; i<3; i++) {
        
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, i*45, 60, 45)];
        titleLB.text = @[@"手机号",@"验证码",@"新密码"][i];
        titleLB.font = [UIFont systemFontOfSize:15];
        titleLB.textColor = titleC1;
        [backV addSubview:titleLB];
    }
    
    phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(75, 5, SCREEN_WIDTH-120, 35)];
    phoneTF.placeholder = @"请输入手机号";
    phoneTF.textColor = titleC1;
    phoneTF.font = [UIFont systemFontOfSize:14];
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [backV addSubview:phoneTF];
    
    VerificationTF = [[UITextField alloc] initWithFrame:CGRectMake(75, 50, SCREEN_WIDTH-220, 35)];
    VerificationTF.placeholder = @"请输入验证码";
    VerificationTF.textColor = titleC1;
    VerificationTF.font = [UIFont systemFontOfSize:14];
    VerificationTF.keyboardType = UIKeyboardTypeNumberPad;
    [backV addSubview:VerificationTF];
    
    UIButton *sender = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-140, 55, 100, 25)];
    sender.backgroundColor = mainBlue;
    [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont systemFontOfSize:14];
    [sender addTarget:self action:@selector(Verification:) forControlEvents:UIControlEventTouchUpInside];
    [self setYuan:sender size:4];
    [backV addSubview:sender];
    
    passTF = [[UITextField alloc] initWithFrame:CGRectMake(75, 95, SCREEN_WIDTH-150, 35)];
    passTF.placeholder = @"请输入密码";
    passTF.textColor = titleC1;
    passTF.font = [UIFont systemFontOfSize:14];
    passTF.keyboardType = UIKeyboardTypeNamePhonePad;
    passTF.secureTextEntry = YES;
    [backV addSubview:passTF];
    
    UIButton *eye = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 95, 35, 35)];
    [eye setImage:[UIImage imageNamed:@"icon_undisplay"] forState:UIControlStateNormal];
    [eye setImage:[UIImage imageNamed:@"icon_display"] forState:UIControlStateSelected];
    [eye addTarget:self action:@selector(eyeAction:) forControlEvents:UIControlEventTouchUpInside];
    [backV addSubview:eye];
    
    UIButton *mainBT = [self setbutton:@"确定" setY:kVIEW_BY(backV)+kHeight(40) add:self.view];
    mainBT.height = 45;
    mainBT.titleLabel.font = [UIFont systemFontOfSize:18];
}

- (void)Verification:(UIButton *)sender {
    
    if ([XYString isValidateMobile:phoneTF.text]) {
        [self setYZM:sender];
    }else {
        [SVProgressHUD showImage:nil status:@"手机号格式错误"];
    }
}

- (void)eyeAction:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
        passTF.secureTextEntry = YES;
    }else {
        sender.selected = YES;
        passTF.secureTextEntry = NO;
    }
}

#pragma mark -- 发送验证码的请求
- (void)setYZM:(UIButton *)sender {
    
    [AVOSCloud requestSmsCodeWithPhoneNumber:phoneTF.text callback:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [SVProgressHUD showSuccessWithStatus:@"已发送"];
            [sender startWithTime:60 title:@"获取验证码" countDownTitle:@"s重新获取" mainColor:mainBlue countColor:[UIColor grayColor]];
        }else {
            NSString *msg = [NSString stringWithFormat:@"错误码：%ld",error.code];
            if ([XYString isObjectNull:msg]) {
                [SVProgressHUD showErrorWithStatus:@"发送失败"];
            }else {
                [SVProgressHUD showImage:nil status:msg];
            }
        }
    }];
}

#pragma mark -- 确定的网络请求
- (void)request {
    
    NSString *username = phoneTF.text;
    NSString *password = passTF.text;
    NSString *yzm = VerificationTF.text;
    
    if (username && password && yzm) {
        
        [AVUser requestPasswordResetWithPhoneNumber:username block:^(BOOL succeeded, NSError * _Nullable error) {
            [AVUser resetPasswordWithSmsCode:yzm newPassword:password block:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    NSString *msg = [NSString stringWithFormat:@"%@",error.userInfo[@"error"]];
                    if ([XYString isObjectNull:msg]) {
                        [SVProgressHUD showMessage:@"修改失败"];
                    }else {
                        [SVProgressHUD showMessage:msg];
                    }
                }
            }];
        }];
    }
}

- (void)mainAction {
    if (phoneTF.text.length==0) {
        [SVProgressHUD showImage:nil status:@"手机号不能为空"];
    }else if (VerificationTF.text.length==0) {
        [SVProgressHUD showImage:nil status:@"验证码不能为空"];
    }else if (passTF.text.length==0) {
        [SVProgressHUD showImage:nil status:@"密码不能为空"];
    }else {
        [self request];
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

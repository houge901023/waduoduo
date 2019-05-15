//
//  registeredVC.m
//  waduoduo
//
//  Created by 名侯 on 2017/4/24.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import "registeredVC.h"
#import "UIButton+WT.h"
#import "registeredInfoVC.h"
#import "TWSelectCityView.h"

@interface registeredVC () <UIActionSheetDelegate>
{
    UITextField *phoneTF;
    UITextField *VerificationTF;
    UITextField *passTF;
    
    UITextField *nameTF;
    UITextField *typeTF;
    UITextField *addressTF;
}
@end

@implementation registeredVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.hidden = YES;
    self.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setup];
}

- (void)setup {
    
    
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(15, JLNavH+16, SCREEN_WIDTH-30, 135)];
    [self setYuan:backV size:5];
    [self setBorder:backV size:1];
    [self.view addSubview:backV];
    
    [self PixeH:CGPointMake(0, 44) lenght:SCREEN_WIDTH-30 add:backV];
    [self PixeH:CGPointMake(0, 89) lenght:SCREEN_WIDTH-30 add:backV];
    
    for (int i=0; i<3; i++) {
        
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, i*45, 60, 45)];
        titleLB.text = @[@"手机号",@"验证码",@"密码"][i];
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
    
    //第二部分
    UIView *backV2 = [[UIView alloc] initWithFrame:CGRectMake(15, kVIEW_BY(backV)+20, SCREEN_WIDTH-30, 135)];
    [self setYuan:backV2 size:5];
    [self setBorder:backV2 size:1];
    [self.view addSubview:backV2];
    
    [self PixeH:CGPointMake(0, 44) lenght:SCREEN_WIDTH-30 add:backV2];
    [self PixeH:CGPointMake(0, 89) lenght:SCREEN_WIDTH-30 add:backV2];
    
    for (int i=0; i<3; i++) {
        
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, i*45, 60, 45)];
        titleLB.text = @[@"用户名",@"职业",@"所在地"][i];
        titleLB.font = [UIFont systemFontOfSize:15];
        titleLB.textColor = titleC1;
        [backV2 addSubview:titleLB];
    }
    
    nameTF = [[UITextField alloc] initWithFrame:CGRectMake(75, 5, SCREEN_WIDTH-120, 35)];
    nameTF.placeholder = @"请输入姓名或昵称";
    nameTF.textColor = titleC1;
    nameTF.font = [UIFont systemFontOfSize:14];
    [backV2 addSubview:nameTF];
    
    typeTF = [[UITextField alloc] initWithFrame:CGRectMake(75, 50, SCREEN_WIDTH-150, 35)];
    typeTF.placeholder = @"请选择职业";
    typeTF.textColor = titleC1;
    typeTF.font = [UIFont systemFontOfSize:14];
    [backV2 addSubview:typeTF];
    
    UIButton *role = [[UIButton alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH-30, 45)];
    [role addTarget:self action:@selector(roleAction) forControlEvents:UIControlEventTouchUpInside];
    [backV2 addSubview:role];
    
    addressTF = [[UITextField alloc] initWithFrame:CGRectMake(75, 95, SCREEN_WIDTH-150, 35)];
    addressTF.placeholder = @"请选择省／市";
    addressTF.textColor = titleC1;
    addressTF.font = [UIFont systemFontOfSize:14];
    [backV2 addSubview:addressTF];
    
    UIButton *address = [[UIButton alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH-30, 45)];
    [address addTarget:self action:@selector(addressAction) forControlEvents:UIControlEventTouchUpInside];
    [backV2 addSubview:address];
    
    UIButton *mainBT = [self setbutton:@"确定" setY:kVIEW_BY(backV2)+kHeight(40) add:self.view];
    mainBT.height = 45;
    mainBT.titleLabel.font = [UIFont systemFontOfSize:18];
    
}

#pragma mark -- 发送验证码的请求
- (void)setYZM:(UIButton *)sender {
    
    [AVOSCloud requestSmsCodeWithPhoneNumber:phoneTF.text callback:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [EasyTextView showSuccessText:@"已发送"];
            [sender startWithTime:60 title:@"获取验证码" countDownTitle:@"s重新获取" mainColor:mainBlue countColor:[UIColor grayColor]];
        }else {
            NSString *msg = [NSString stringWithFormat:@"错误码：%ld",error.code];
            if ([XYString isObjectNull:msg]) {
                [EasyTextView showErrorText:@"发送失败"];
            }else {
                [EasyTextView showErrorText:msg];
            }
        }
    }];
}

- (void)Verification:(UIButton *)sender {
    
    if ([XYString isValidateMobile:phoneTF.text]) {
        [self setYZM:sender];
    }else {
        [EasyTextView showText:@"手机号格式错误"];
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

- (void)roleAction {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"挖机用户",@"配件商户",@"维修工程师",@"挖机驾驶员",@"挖机行业", nil];
    [sheet showInView:self.view];
}

- (void)addressAction {
    
    [self.view endEditing:YES];
    TWSelectCityView *city = [[TWSelectCityView alloc] initWithTWFrame:self.view.bounds TWselectCityTitle:@"选择地区"];
    [city showCityView:^(NSString *proviceStr, NSString *cityStr, NSString *distr) {
        addressTF.text = [NSString stringWithFormat:@"%@%@%@",proviceStr,cityStr,distr];
        NSLog(@"%@",[NSString stringWithFormat:@"%@->%@->%@",proviceStr,cityStr,distr]);
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==5) {
        
    }else {
        typeTF.text = @[@"挖机用户",@"配件商户",@"维修工程师",@"挖机驾驶员",@"挖机行业"][buttonIndex];
    }
}

- (void)mainAction {
    
    if (phoneTF.text.length==0) {
        [EasyTextView showText:@"手机号不能为空"];
    }else if (VerificationTF.text.length==0) {
        [EasyTextView showText:@"验证码不能为空"];
    }else if (passTF.text.length==0) {
        [EasyTextView showText:@"密码不能为空"];
    }else if (nameTF.text.length==0) {
        [EasyTextView showText:@"姓名不能为空"];
    }else if (typeTF.text.length==0) {
        [EasyTextView showText:@"请选择角色"];
    }else if (addressTF.text.length==0) {
        [EasyTextView showText:@"请选择省／市"];
    }else {
        [self request];
    }
}

#pragma mark -- 注册的网络请求
- (void)request {
    
    [EasyLoadingView showLoadingImage:@"加载中..."];
    
    [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:phoneTF.text smsCode:VerificationTF.text block:^(AVUser * _Nullable user, NSError * _Nullable error) {
        if (!error) {
            
            user.username = nameTF.text;
            user.password = passTF.text;
            [user setObject:@"1" forKey:@"Power"];
            [user setObject:[NSMutableArray array] forKey:@"collection"];
            
            [user setObject:avoidNull(addressTF.text) forKey:@"usercity"];
            [user setObject:avoidNull(typeTF.text) forKey:@"usertype"];
            
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"注册成功");
                    self.success(phoneTF.text,passTF.text);
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [AVUser logOut];
                    [EasyTextView showSuccessText:@"注册成功"];
                } else {
                    NSString *msg = [NSString stringWithFormat:@"%@",error.userInfo[@"error"]];
                    if ([XYString isObjectNull:msg]) {
                        [EasyTextView showErrorText:@"注册失败"];
                    }else {
                        [EasyTextView showErrorText:msg];
                    }
                }
            }];
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@",error.userInfo[@"error"]];
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

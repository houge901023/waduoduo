//
//  LoginVC.m
//  waduoduo
//
//  Created by 名侯 on 2017/4/24.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import "LoginVC.h"
#import "registeredVC.h"
#import "ForgotpassVC.h"
#import <RongIMKit/RongIMKit.h>
#import <AFNetworking.h>

@interface LoginVC () <RCIMUserInfoDataSource>
{
    UITextField *phoneTF;
    UITextField *passTF;
}
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureRightImage:@"icon_out"];
    
    [self setup];
    NSLog(@"当前用户=%@",[AVUser currentUser]);
}

- (void)setup {
    
    //logo
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, kHeight(130), 100, 100)];
    logo.image = [UIImage imageNamed:@"img_logo"];
    [self setYuan:logo size:15];
    [self.view addSubview:logo];
    
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(15, kVIEW_BY(logo)+kHeight(64), SCREEN_WIDTH-30, 90)];
    [self setYuan:backV size:5];
    [self setBorder:backV size:1];
    [self.view addSubview:backV];
    [self PixeH:CGPointMake(0, 44) lenght:SCREEN_WIDTH-30 add:backV];
    
    UIButton *mainBT = [self setbutton:@"登录" setY:kVIEW_BY(backV)+15 add:self.view];
    mainBT.height = 45;
    mainBT.titleLabel.font = [UIFont systemFontOfSize:18];
    
    for (int i=0; i<2; i++) {
        
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, i*45, 60, 45)];
        titleLB.text = @[@"手机号",@"密码"][i];
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
    
    passTF = [[UITextField alloc] initWithFrame:CGRectMake(75, 50, SCREEN_WIDTH-150, 35)];
    passTF.placeholder = @"请输入密码";
    passTF.textColor = titleC1;
    passTF.font = [UIFont systemFontOfSize:14];
    passTF.keyboardType = UIKeyboardTypeNamePhonePad;
    passTF.secureTextEntry = YES;
    [backV addSubview:passTF];
    
    UIButton *eye = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 50, 35, 35)];
    [eye setImage:[UIImage imageNamed:@"icon_undisplay"] forState:UIControlStateNormal];
    [eye setImage:[UIImage imageNamed:@"icon_display"] forState:UIControlStateSelected];
    [eye addTarget:self action:@selector(eyeAction:) forControlEvents:UIControlEventTouchUpInside];
    [backV addSubview:eye];
    
    for (int i=0; i<2; i++) {
        
        UIButton *sender = [[UIButton alloc] initWithFrame:CGRectMake(15+i*(SCREEN_WIDTH-30)/2, kVIEW_BY(mainBT)+10, (SCREEN_WIDTH-30)/2, 45)];
        [sender setTitle:@[@"注册",@"忘记密码"][i] forState:UIControlStateNormal];
        [sender setTitleColor:@[mainBlue,titleC2][i] forState:UIControlStateNormal];
        sender.titleLabel.font = [UIFont systemFontOfSize:16];
        sender.tag = 1000+i;
        [sender addTarget:self action:@selector(otherAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:sender];
    }
    [self PixeV:CGPointMake(SCREEN_WIDTH/2, kVIEW_BY(mainBT)+20) lenght:25 add:self.view];
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

- (void)mainAction {
    if (phoneTF.text.length==0) {
        [SVProgressHUD showMessage:@"手机号不能为空"];
    }else if (passTF.text.length==0) {
        [SVProgressHUD showImage:nil status:@"请输入密码"];
    }else {
        [self request];
    }
}

#pragma mark -- 登录的网络请求
- (void)request {
    
    [SVProgressHUD showWithStatus:@"加载中..."];
 
    [AVUser logInWithMobilePhoneNumberInBackground:phoneTF.text password:passTF.text block:^(AVUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            NSString *msg = [NSString stringWithFormat:@"%@",error.userInfo[@"error"]];
            if ([XYString isObjectNull:msg]) {
                [SVProgressHUD showImage:nil status:@"登录失败"];
            }else {
                [SVProgressHUD showImage:nil status:msg];
            }
        } else {
            //获取聊天token
            [self getRCIMtoken:user];
        }
    }];
}

#pragma -- 登录成功获取 融云token
- (void)getRCIMtoken:(AVUser *)user {

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30.f;
    
    NSString *urlstr =@"https://api.cn.rong.io/user/getToken.json";
    NSDictionary *dic =@{@"userId":avoidNull(user.objectId),
                         @"name":avoidNull(user.username),
                         @"portraitUri":avoidNull(user[@"iconHead"])
                         };
    
    NSString * timestamp = [[NSString alloc] initWithFormat:@"%ld",(NSInteger)[NSDate timeIntervalSinceReferenceDate]];
    NSString * nonce = [NSString stringWithFormat:@"%d",arc4random()];
    NSString * appkey = @"3argexb63u8le";
    NSString * Signature = [NSString stringWithFormat:@"%@%@%@",appkey,nonce,timestamp];
    //以下拼接请求内容
    [manager.requestSerializer setValue:appkey forHTTPHeaderField:@"App-Key"];
    [manager.requestSerializer setValue:nonce forHTTPHeaderField:@"Nonce"];
    [manager.requestSerializer setValue:timestamp forHTTPHeaderField:@"Timestamp"];
    [manager.requestSerializer setValue:Signature forHTTPHeaderField:@"Signature"];
    [manager.requestSerializer setValue:@"IGnguV1wSjQ6f" forHTTPHeaderField:@"appSecret"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //开始请求
    [manager POST:urlstr parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"成功返回=%@",dic);
        
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self setUserifon:avoidNull(dic[@"token"]) andKey:@"IMtoken"];
        [self initRCIMtoken:avoidNull(dic[@"token"])];
        APP_DELE.refreshNum = 2;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [AVUser logOut];
        [SVProgressHUD showMessage:@"服务器繁忙，稍后重试"];
    }];
    
}

#pragma mark -- 登录融云服务器
- (void)initRCIMtoken:(NSString *)token {
    
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        
        [[RCIM sharedRCIM] setEnableTypingStatus:YES];
        [[RCIM sharedRCIM] setEnableMessageMentioned:YES];
        [[RCIM sharedRCIM] setGlobalMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        
    } error:^(RCConnectErrorCode status) {
        [SVProgressHUD showMessage:@"初始化消息失败，重新启动"];
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
    }];
}

#pragma mark -- 融云会话列表
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
    NSLog(@"用户id=%@",userId);
    AVUser *bbb = [AVQuery getUserObjectWithId:userId];
    
    RCUserInfo *use = [[RCUserInfo alloc] init];
    use.name = avoidNull(bbb.username);
    use.portraitUri = bbb[@"iconHead"];
    completion(use);
}

- (void)otherAction:(UIButton *)sender {
    if (sender.tag==1000) {
        registeredVC *MVC = [[registeredVC alloc] init];
        [MVC setSuccess:^(NSString *phone, NSString *pass) {
            phoneTF.text = phone;
            passTF.text = pass;
        }];
        [self.navigationController pushViewController:MVC animated:YES];
    }else {
        ForgotpassVC *MVC = [[ForgotpassVC alloc] init];
        [self.navigationController pushViewController:MVC animated:YES];
    }
}

- (void)rightNavAction {
    [self dismissViewControllerAnimated:YES completion:nil];
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

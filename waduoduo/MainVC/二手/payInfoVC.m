//
//  payInfoVC.m
//  waduoduo
//
//  Created by Apple  on 2019/4/23.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import "payInfoVC.h"

@interface payInfoVC ()

@end

@implementation payInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购买成功";
    
    if (self.isSuccess == 1) {
        self.titleLB.text = @"购买成功，已添加到我的客户";
        [self.phoneBtn setTitle:[NSString stringWithFormat:@"拨打手机:%@",self.tel] forState:UIControlStateNormal];
    }else if (self.isSuccess == 2){
        self.titleLB.text = @"购买成功，请截图保存手机号，否则无法找回";
        [self.phoneBtn setTitle:[NSString stringWithFormat:@"拨打手机:%@",self.tel] forState:UIControlStateNormal];
    }else {
        self.titleLB.text = @"出错了，数据更新失败。请截图保存然后，短信发送截图和您的注册手机号到 17711319726（我们后台手动为您添加权限）";
        [self.phoneBtn setTitle:@"发送短信：17711319726" forState:UIControlStateNormal];
    }
}

- (IBAction)openTel {
    
    if (self.isSuccess == 3) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://17711319726"]];
    }else {
        NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"tel:%@",self.tel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    }
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

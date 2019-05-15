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
    
    if (self.isSuccess) {
        self.titleLB.text = @"购买成功，已添加到我的客户";
        [self.phoneBtn setTitle:[NSString stringWithFormat:@"拨打手机:%@",self.tel] forState:UIControlStateNormal];
    }else {
        self.titleLB.text = @"购买成功，请截图保存手机号，否则无法找回";
        [self.phoneBtn setTitle:[NSString stringWithFormat:@"拨打手机:%@",self.tel] forState:UIControlStateNormal];
    }
}

- (IBAction)openTel {
    NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"tel:%@",self.tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
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

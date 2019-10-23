//
//  RepairOrderVC.m
//  SouMi
//
//  Created by Apple  on 2019/4/4.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import "RepairOrderVC.h"

@interface RepairOrderVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UITextView *contextV;
@property (weak, nonatomic) IBOutlet UITextField *orderTF;
@property (weak, nonatomic) IBOutlet UITextField *teleTF;
@property (weak, nonatomic) IBOutlet UILabel *infoLB;

@end

@implementation RepairOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"问题反馈";
    [self.NavRight setTitle:@"提交" forState:UIControlStateNormal];
    self.top.constant = JLNavH+15;
}

- (void)rightAction {
    
    if (self.contextV.text.length>150 || self.contextV.text.length == 0) {
        [EasyTextView showText:@"问题描述不能为空或超过150个字符"];
        return;
    }else if (self.orderTF.text.length>20) {
        [EasyTextView showText:@"订单号不能超过20个字符"];
        return;
    }else if (self.teleTF.text.length>20 || self.teleTF.text.length == 0) {
        [EasyTextView showText:@"联系方式不能为空或超过20个字符"];
        return;
    }else {
        [self request];
    }
}

- (void)request {
    
    AVObject *product = [AVObject objectWithClassName:@"Feedback"];
    [product setObject:self.contextV.text forKey:@"context"];
    [product setObject:self.orderTF.text forKey:@"order"];
    [product setObject:self.teleTF.text forKey:@"contact"];
    
    [EasyLoadingView showLoadingText:@"加载中..."];
    [product saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [EasyTextView showSuccessText:@"提交成功"];
            self.infoLB.text = @"请耐心等待，运营正在处理你提交的问题，后续会跟踪并联系你";
        } else {
            [EasyTextView showErrorText:@"提交失败"];
        }
    }];
    
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

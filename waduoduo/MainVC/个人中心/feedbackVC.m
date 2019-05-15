//
//  feedbackVC.m
//  waduoduo
//
//  Created by 名侯 on 2017/5/12.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import "feedbackVC.h"
#import "WTTextView.h"

@interface feedbackVC ()
{
    WTTextView *textTV;
}
@end

@implementation feedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self configureRight:@"提交"];
    
    [self setup];
}

- (void)setup {
    
    textTV = [[WTTextView alloc] initWithFrame:CGRectMake(15, JLNavH+20, SCREEN_WIDTH-30, kWidth(200))];
    textTV.placeHolder = @"请填写意见反馈";
    [self.view addSubview:textTV];
    
    [self setYuan:textTV size:kWidth(5)];
    [self setBorder:textTV size:1 withColor:BorderColor];
    
}

- (void)rightNavAction {
    
    if (textTV.text.length==0) {
        [EasyTextView showText:@"内容不能为空"];
    }else {
        [self request];
    }
}

- (void)request {
    
    AVObject *product = [AVObject objectWithClassName:@"Feedback"];
    [product setObject:textTV.text forKey:@"context"];
    [product setObject:[[NSDate date] string] forKey:@"date"];
    [product setObject:[AVUser currentUser].mobilePhoneNumber forKey:@"phone"];
    
    [EasyLoadingView showLoadingImage:@"正在加载中..."];
    [product saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [EasyTextView showSuccessText:@"提交成功"];
//            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [EasyTextView showErrorText:@"提交失败"];
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

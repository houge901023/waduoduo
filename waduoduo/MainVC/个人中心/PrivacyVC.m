//
//  PrivacyVC.m
//  FinanceSchool
//
//  Created by Apple  on 2019/1/11.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "PrivacyVC.h"

@interface PrivacyVC () <UIWebViewDelegate>

@property (nonatomic ,weak) UILabel *msgLB;

@end

@implementation PrivacyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"隐私政策";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, JLNavH, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH)];
    webView.delegate = self;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    NSURL *url = [[NSURL alloc]initWithString:@"https://www.rrxiu.net/view-jxy0q2"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    webView.userInteractionEnabled = NO;

    [self showLoding:FrameNav setText:@"正在加载中..."];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(show) userInfo:nil repeats:NO];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    [EasyEmptyView showErrorInView:self.maskView callback:^(EasyEmptyView *view, UIButton *button, callbackType callbackType) {
        [EasyEmptyView hiddenEmptyInView:self.maskView];
        [self showLoding:FrameNav setText:@"正在加载中..."];
        
        NSURL *url = [[NSURL alloc]initWithString:@"https://www.rrxiu.net/view-jxy0q2"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
    }];
}
- (void)show {
    [self hidenLoding];
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

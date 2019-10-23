//
//  webVC.m
//  SouMi
//
//  Created by Apple  on 2019/4/4.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import "webVC.h"

@interface webVC () <UIWebViewDelegate>

@property (nonatomic ,weak) UILabel *msgLB;

@end

@implementation webVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"隐私政策";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, JLNavH, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH)];
    webView.delegate = self;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    NSURL *url = [[NSURL alloc]initWithString:@"https://m.rrxiu.me/?v=kgkkpl&vt=2"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    webView.userInteractionEnabled = NO;
    
    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, JLNavH, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH)];
    titleLB.backgroundColor = [UIColor whiteColor];
    titleLB.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLB];
    _msgLB = titleLB;
    [EasyLoadingView showLoadingText:@"数据加载中..."];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(show) userInfo:nil repeats:NO];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [EasyTextView showErrorText:@"访问失败，退出重试"];
}
- (void)show {
    [EasyLoadingView hidenLoading];
    _msgLB.hidden = YES;
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

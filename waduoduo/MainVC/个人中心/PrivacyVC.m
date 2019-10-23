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
//    NSURL *url = [[NSURL alloc]initWithString:@"https://rrx.cn/view-jxy0q2"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [webView loadRequest:request];
    
    [webView loadHTMLString:[self url] baseURL:nil];
    [self.view addSubview:webView];
//    webView.userInteractionEnabled = NO;

    [self showLoding:FrameNav setText:@"正在加载中..."];
}

- (NSString *)url {
    
    NSString *str = @"<p style=\"font-size: 18px;\">一、为了您可以正常使用我们的服务，我们会在下列情形下收集您的相关个人信息，同时也可能通过合法存储您相关信息的第三方收集您的个人信息:\n1、账户注册\n您在注册挖多多账户或使用挖多多服务时，可能需要提供您的姓名、联系方式、地址等信息，以便完成账户注册并正常使用我们的相关服务。\n2、保障安全\n为提高您使用我们的产品与/或服务时系统的安全性，更准确地预防钓鱼网站欺诈和保护账户安全，我们可能会通过了解您的浏览信息、您常用的软件信息、设备信息、用户行为信息等手段来判断您的账号风险，并可能会记录- -些技术判断为异常的链接地址;我们也会收集您的设备信息用作问题进行分析，统计流量并排查可能存在的风险。\n3、服务改进\n我们可能会收集您的个人信息进行数据分析用以为您提供个性化定制的服务,或用其为我们的服务进行未来的改进和调整。\n二、我们承诺对您的信息进行保密，我们会在以下情形使用您的个人信息:\n1、遵守国家法律法规及监管规定，为顺利向您提供服务，或提升您的服务体验，实现本指引中“我们如何收集个人信息”章节所述目的。\n2、向您发送电子信息，或提供与您相关的产品信息。如您不希望接此类内容,您可通过回复短信退订以拒绝该类短信。\n3、共享:在和第三方(如与挖多多关联公司、挖多多供应商等组织机构)共享您的个人信息前，我们会对其个人信息安全防护能力水平提出要求，确认其采集个人信息行为的合法性、正当性、安全性、必要性，对其查询行为及进行监控，督促其遵守国家法律法规及协议中约定的安全防护措施和保密条例，一旦发现其违反协议约定将会采取有效措施甚至终止合作。以下情形会共享您的个人信息:\n(1)经过您的明确授权或同意的;\n(2)为了提供需要和第三方(共享信息才能提供的服务，如抽奖活动、竞赛活动;\n(3)为了处理您的交易纠纷或争议，需要与银行或交易方共享交易信息;\n(4)公司进行合并、被收购、IPO及其它资本活动时,我们会把您的个人信息共享给必要的主体，并要求其签署保密协议;\n(5)在国家法律法规允许的范围内，授权已取得您明确同意的第三方向我们查询、采集您在挖多多的个人信息。\n4、转让:未经您的授权或同意，我们不会将您的个人信息转让给任何组织和个人，但是涉及到公司合并、收购或破产清算时，有可能会将您的个人信息转让给新的组织，届时，我们会要求其以通知确认的形式征求您的同意，并要求其遵守本隐私保护指引。\n5、公示:未经您的授权或同意，原则上我们不会公开披露您的个人信息，但在公布中奖活动名单的情况下，需要公示的中奖用户登录名以及脱敏后的中奖用户手机号码除外。\n6、当我们要将您的个人信息用于其它用途时，我们会以通知确认的形式征求您的同意。</p>";
    
    return str;
    
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

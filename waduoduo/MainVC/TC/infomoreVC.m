//
//  infomoreVC.m
//  waduoduo
//
//  Created by Apple  on 2019/8/6.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import "infomoreVC.h"
#import "SDPhotoBrowser.h"

@interface infomoreVC () <UIWebViewDelegate,SDPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet UILabel *contentLB;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Top;
@property (weak, nonatomic) IBOutlet UIView *backView2;
@property (weak, nonatomic) IBOutlet UILabel *titleLB2;

@end

@implementation infomoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付说明";
    
    self.Top.constant = JLNavH+20;
    self.contentLB.text = @"通过添加好友（微信、QQ），完成支付后截图发送给我们（下载二维码，识别二维码支付），我们把全部详情截图发给您。";
    
    NSString *str = [NSString stringWithFormat:@"价格：%@元",self.price];
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:str];
    [attstr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:23]} range:NSMakeRange(3, self.price.length)];
    self.titleLB2.attributedText = attstr;
    
    [self setUI];
}

- (void)setUI {
    
    CGFloat jx = (SCREEN_WIDTH-40-220)/3;
    
    for (int i=0; i<2; i++) {
        
        UIImageView *ewm = [[UIImageView alloc] initWithFrame:CGRectMake(jx+i*(110+jx), 0, 110, 110)];
        ewm.image = [UIImage imageNamed:@[@"zfb02",@"zfb02"][i]];
        ewm.tag = 3000+i;
        ewm.userInteractionEnabled = YES;
        [self.backView addSubview:ewm];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [ewm addGestureRecognizer:tap];
        
    }
    
    for (int i=0; i<2; i++) {
        
        UIButton *send = [[UIButton alloc] initWithFrame:CGRectMake(0, 115, 100, 30)];
        send.tag = 1000+i;
        send.backgroundColor = mainBlue;
        [send setTitle:@[@"微信",@"支付宝"][i] forState:UIControlStateNormal];
        [send setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [send addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
        [self setYuan:send size:15];
        
        UIView *ewm = [self.backView viewWithTag:3000+i];
        send.centerX = ewm.centerX;
        [self.backView addSubview:send];
    }
    
    
    
    for (int i=0; i<2; i++) {
        
        UIButton *send = [[UIButton alloc] initWithFrame:CGRectMake(jx+i*(110+jx), 0, 110, 60)];
        send.tag = 2000+i;
        [send setImage:[UIImage imageNamed:@[@"wx",@"qq"][i]] forState:UIControlStateNormal];
        [send addTarget:self action:@selector(contact:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView2 addSubview:send];
    }
}

- (void)download:(UIButton *)sender {
 
    [self loadImageFinished:[UIImage imageNamed:@[@"zfb01",@"zfb01"][sender.tag-1000]]];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = tap.view.tag-3000;
    browser.sourceImagesContainerView = self.backView;
    browser.imageCount = 2;
    browser.delegate = self;
    [browser show];
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return [UIImage imageNamed:@[@"zfb01",@"zfb01"][index]];
}

- (void)contact:(UIButton *)sender {
    
    if (sender.tag == 2001) {
        //你的客服号码。
        NSString  *qqNumber=@"2280246875";
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
            NSURL * url=[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qqNumber]];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            webView.delegate = self;
            [webView loadRequest:request];
            [self.view addSubview:webView];
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"对不起，您还没安装QQ" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                return ;
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }else {
        NSURL * url = [NSURL URLWithString:@"weixin://"];
        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
        //先判断是否能打开该url
        if (canOpen) {   //打开微信
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"已复制微信号：qmjs026 (进入添加朋友界面粘贴即可）" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = @"qmjs026";
                [[UIApplication sharedApplication] openURL:url];
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"对不起，您还没安装微信" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                return ;
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }

}

- (void)loadImageFinished:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    if (error) {
        [EasyTextView showText:@" >_< 保存失败 "];
    }else {
        [EasyTextView showText:@" ^_^ 保存成功，请到相册查看 "];
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

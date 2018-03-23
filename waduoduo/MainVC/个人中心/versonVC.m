//
//  versonVC.m
//  waduoduo
//
//  Created by 名侯 on 2017/5/12.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import "versonVC.h"

@interface versonVC ()

@end

@implementation versonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    
    [self setup];
    
}

- (void)setup {
    
    UIImageView *iconV = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, kHeight(145), 100, 100)];
    iconV.image = [UIImage imageNamed:@"img_logo"];
    [self setYuan:iconV size:15];
    [self.view addSubview:iconV];
    
    UILabel *versionLB = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, kVIEW_BY(iconV)+kHeight(10), 80, kHeight(20))];
    versionLB.textColor = UIColorFromRGB(0x333333);
    versionLB.font = [UIFont systemFontOfSize:font(15)];
    versionLB.textAlignment = NSTextAlignmentCenter;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *version = [NSString stringWithFormat:@"v %@",app_Version];
    versionLB.text = version;
    [self.view addSubview:versionLB];
    
    // 电话
    UILabel *teleLB = [[UILabel alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT-kHeight(75), SCREEN_WIDTH-40, kHeight(20))];
    teleLB.textColor = UIColorFromRGB(0x333333);
    teleLB.font = [UIFont systemFontOfSize:font(15)];
    teleLB.textAlignment = NSTextAlignmentCenter;
    teleLB.hidden = YES;
    teleLB.text = @"服务热线：028-5452444";
    [self.view addSubview:teleLB];
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

//
//  MorePlanVC.m
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/16.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import "MorePlanVC.h"
#import "MorePlanListVC.h"

@interface MorePlanVC () <UIScrollViewDelegate>

@property (nonatomic, weak) UIButton *seletBtn;
@property (nonatomic, weak) UIView *underline;
@property (nonatomic, weak) UIScrollView *mainSV;

@property (nonatomic, strong) MorePlanListVC *allC;
@property (nonatomic, strong) MorePlanListVC *footC;
@property (nonatomic, strong) MorePlanListVC *basketC;
@property (nonatomic, strong) MorePlanListVC *fourteenC;
@property (nonatomic, strong) MorePlanListVC *nineC;

@end

@implementation MorePlanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部方案";
    
    [self setUI];
}
- (void)setUI {
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, JLNavH, SCREEN_WIDTH, 40)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self PixeH:CGPointMake(0, 39) lenght:SCREEN_WIDTH add:titleView];
    [self.view addSubview:titleView];
    
    for (int i=0; i<5; i++) {
        UIButton *Btn = [[UIButton alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH/5, 0, SCREEN_WIDTH/5, 40)];
        [Btn setTitle:@[@"全部",@"足球",@"篮球",@"胜负",@"任九"][i] forState:UIControlStateNormal];
        [Btn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [Btn setTitleColor:COLOR_MAIN forState:UIControlStateSelected];
        Btn.titleLabel.font = [UIFont systemFontOfSize:14];
        Btn.tag = 1000+i;
        [Btn addTarget:self action:@selector(titleAction:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:Btn];
//        if (i==2) {
//            Btn.selected = YES;
//            self.seletBtn = Btn;
//        }
    }
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 39, 60, 1)];
    lineV.backgroundColor = COLOR_MAIN;
    lineV.center = CGPointMake(SCREEN_WIDTH/10, 39.5);
    [titleView addSubview:lineV];
    self.underline = lineV;
    
    UIScrollView *ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, JLNavH+40, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH-40)];
    ScrollView.contentSize = CGSizeMake(5*SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH-40);
    ScrollView.delegate = self;
    ScrollView.showsHorizontalScrollIndicator = NO;
    ScrollView.bounces = NO;
    ScrollView.pagingEnabled = YES;
    ScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    [self.view addSubview:ScrollView];
    self.mainSV = ScrollView;
    
    [ScrollView addSubview:self.allC.mainTV];
    [ScrollView addSubview:self.footC.mainTV];
    [ScrollView addSubview:self.basketC.mainTV];
    [ScrollView addSubview:self.fourteenC.mainTV];
    [ScrollView addSubview:self.nineC.mainTV];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offx = scrollView.contentOffset.x;
    self.underline.center = CGPointMake(SCREEN_WIDTH/10+offx/5, 39.5);

    NSInteger a = (offx+SCREEN_WIDTH/5)/SCREEN_WIDTH;
    self.seletBtn.selected = !self.seletBtn.selected;
    UIButton *btn = (UIButton *)[self.view viewWithTag:1000+a];
    btn.selected = YES;
    self.seletBtn = btn;
}
- (void)titleAction:(UIButton *)sender {
    
    self.seletBtn.selected = !self.seletBtn.selected;
    sender.selected = YES;
    self.seletBtn = sender;
    [self.mainSV setContentOffset:CGPointMake(SCREEN_WIDTH*(sender.tag-1000), 0) animated:NO];
}

- (MorePlanListVC *)allC {
    if (_allC==nil) {
        _allC = [[MorePlanListVC alloc] init];
        _allC.mainTV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH-40);
        _allC.type = @"0";
        [self addChildViewController:_allC];
        [self.view addSubview:_allC.view];
        _allC.view.hidden = YES;
    }
    return _allC;
}
- (MorePlanListVC *)footC {
    if (_footC==nil) {
        _footC = [[MorePlanListVC alloc] init];
        _footC.mainTV.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH-40);
        _footC.type = @"1";
        [self addChildViewController:_footC];
        [self.view addSubview:_footC.view];
        _footC.view.hidden = YES;
    }
    return _footC;
}
- (MorePlanListVC *)basketC {
    if (_basketC==nil) {
        _basketC = [[MorePlanListVC alloc] init];
        _basketC.mainTV.frame = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH-40);
        _basketC.type = @"2";
        [self addChildViewController:_basketC];
        [self.view addSubview:_basketC.view];
        _basketC.view.hidden = YES;
    }
    return _basketC;
}
- (MorePlanListVC *)fourteenC {
    if (_fourteenC==nil) {
        _fourteenC = [[MorePlanListVC alloc] init];
        _fourteenC.mainTV.frame = CGRectMake(SCREEN_WIDTH*3, 0, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH-40);
        _fourteenC.type = @"3";
        [self addChildViewController:_fourteenC];
        [self.view addSubview:_fourteenC.view];
        _fourteenC.view.hidden = YES;
    }
    return _fourteenC;
}
- (MorePlanListVC *)nineC {
    if (_nineC==nil) {
        _nineC = [[MorePlanListVC alloc] init];
        _nineC.mainTV.frame = CGRectMake(SCREEN_WIDTH*4, 0, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH-40);
        _nineC.type = @"4";
        [self addChildViewController:_nineC];
        [self.view addSubview:_nineC.view];
        _nineC.view.hidden = YES;
    }
    return _nineC;
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

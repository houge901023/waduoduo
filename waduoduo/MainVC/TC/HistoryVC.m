//
//  HistoryVC.m
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/16.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import "HistoryVC.h"
#import "HistoryListVC.h"

@interface HistoryVC () <UIScrollViewDelegate>

@property (nonatomic, weak) UIButton *seletBtn;
@property (nonatomic, weak) UIView *underline;
@property (nonatomic, weak) UIScrollView *mainSV;

@property (nonatomic, strong) HistoryListVC *duringC;
@property (nonatomic, strong) HistoryListVC *endC;

@end

@implementation HistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    self.title = self.name;
    [self setUI];
//    [self setRequest];
}

- (void)setUI {
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, JLNavH, SCREEN_WIDTH, 40)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self PixeH:CGPointMake(0, 39) lenght:SCREEN_WIDTH add:titleView];
    [self.view addSubview:titleView];
    
    for (int i=0; i<2; i++) {
        UIButton *Btn = [[UIButton alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 40)];
        [Btn setTitle:@[@"比赛中",@"已结束"][i] forState:UIControlStateNormal];
        [Btn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [Btn setTitleColor:COLOR_MAIN forState:UIControlStateSelected];
        Btn.titleLabel.font = [UIFont systemFontOfSize:16];
        Btn.tag = 1000+i;
        [Btn addTarget:self action:@selector(titleAction:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:Btn];
        if (i==1) {
            Btn.selected = YES;
            self.seletBtn = Btn;
        }
    }
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 39, 80, 1)];
    lineV.backgroundColor = COLOR_MAIN;
    lineV.center = CGPointMake(SCREEN_WIDTH*3/4, 39.5);
    [titleView addSubview:lineV];
    self.underline = lineV;
    
    UIScrollView *ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, JLNavH+40, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH-40)];
    ScrollView.contentSize = CGSizeMake(2*SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH-40);
    ScrollView.delegate = self;
    ScrollView.showsHorizontalScrollIndicator = NO;
    ScrollView.bounces = NO;
    ScrollView.pagingEnabled = YES;
    ScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    [self.view addSubview:ScrollView];
    self.mainSV = ScrollView;
    
    [ScrollView addSubview:self.endC.mainTV];
    [ScrollView addSubview:self.duringC.mainTV];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offx = scrollView.contentOffset.x;
    self.underline.center = CGPointMake(SCREEN_WIDTH/4+offx/2, 39.5);
    if (offx==0) {
        self.seletBtn.selected = !self.seletBtn.selected;
        UIButton *btn = (UIButton *)[self.view viewWithTag:1000];
        btn.selected = YES;
        self.seletBtn = btn;
    }else if (offx==SCREEN_WIDTH) {
        self.seletBtn.selected = !self.seletBtn.selected;
        UIButton *btn = (UIButton *)[self.view viewWithTag:1001];
        btn.selected = YES;
        self.seletBtn = btn;
    }
}
- (void)titleAction:(UIButton *)sender {
    
    self.seletBtn.selected = !self.seletBtn.selected;
    sender.selected = YES;
    self.seletBtn = sender;
    if (sender.tag==1000) {
        [self.mainSV setContentOffset:CGPointMake(0, 0) animated:NO];
    }else {
        [self.mainSV setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
    }
}

- (HistoryListVC *)duringC {
    if (_duringC==nil) {
        _duringC = [[HistoryListVC alloc] init];
        _duringC.mainTV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH-40);
        _duringC.type = @"2";
        _duringC.ExpertsNo = self.ExpertsNo;
        [self addChildViewController:_duringC];
        [self.view addSubview:_duringC.view];
        _duringC.view.hidden = YES;
    }
    return _duringC;
}
- (HistoryListVC *)endC {
    if (_endC==nil) {
        _endC = [[HistoryListVC alloc] init];
        _endC.mainTV.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH-40);
        _endC.type = @"3";
        _endC.ExpertsNo = self.ExpertsNo;
        [self addChildViewController:_endC];
        [self.view addSubview:_endC.view];
        _endC.view.hidden = YES;
    }
    return _endC;
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

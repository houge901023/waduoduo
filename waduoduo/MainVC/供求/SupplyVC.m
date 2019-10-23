//
//  SupplyVC.m
//  waduoduo
//
//  Created by 名侯 on 2017/4/20.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import "SupplyVC.h"
#import "PartsVC.h"
#import "DemandVC.h"
#import "MainVC.h"

@interface SupplyVC ()

@property (nonatomic ,strong) PartsVC *parts;
@property (nonatomic ,strong) DemandVC *demand;

@end

@implementation SupplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBarView.hidden = NO;
    [self setup];
//    
//    MainVC *main = [[MainVC alloc] init];
//    MainNavigationController *NAV = [[MainNavigationController alloc] initWithRootViewController:main];
//    [self presentViewController:NAV animated:NO completion:^{
//        main.NavLeft.hidden = YES;
//    }];
}

- (void)setup {
    
    UISegmentedControl *segM = [[UISegmentedControl alloc] initWithItems:@[@"供应",@"求购"]];
    segM.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 30);
    segM.tintColor = mainBlue;
    segM.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segM;
    [segM addTarget:self action:@selector(segmAction:) forControlEvents:UIControlEventValueChanged];
    
    self.parts.view.hidden = NO;
}

- (void)segmAction:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex==0) {
        self.parts.view.hidden = NO;
        self.demand.view.hidden = YES;
    }else {
        self.parts.view.hidden = YES;
        self.demand.view.hidden = NO;
    }
}

- (PartsVC *)parts {
    
    if (_parts==nil) {
        _parts = [[PartsVC alloc] init];
        _parts.userId = self.userId;
        _parts.Personal = self.Personal;
        [self addChildViewController:_parts];
        [self.view addSubview:_parts.view];
    }
    return _parts;
}

- (DemandVC *)demand {
    
    if (_demand==nil) {
        _demand = [[DemandVC alloc] init];
        _demand.userId = self.userId;
        _demand.Personal = self.Personal;
        [self addChildViewController:_demand];
        [self.view addSubview:_demand.view];
    }
    return _demand;
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

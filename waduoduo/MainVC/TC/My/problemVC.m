//
//  problemVC.m
//  SouMi
//
//  Created by Apple  on 2019/4/3.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import "problemVC.h"
#import "NSDate+Utils.h"

@interface problemVC ()

@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *contextLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@end

@implementation problemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"出问题了";
    self.NavLeft.hidden = YES;
    self.top.constant = JLNavH;
    self.timeLB.text = [[NSDate date] stringYearMonthDayHourMinuteSecond];
    
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

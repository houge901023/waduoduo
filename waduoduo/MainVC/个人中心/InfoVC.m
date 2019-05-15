//
//  InfoVC.m
//  waduoduo
//
//  Created by Apple  on 2019/3/28.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import "InfoVC.h"

@interface InfoVC ()

@property (weak, nonatomic) IBOutlet UILabel *contextLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@end

@implementation InfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助";
    
    self.top.constant = JLNavH+15;
    self.contextLB.text = self.str;

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

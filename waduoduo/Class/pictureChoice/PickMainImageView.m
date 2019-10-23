//
//  PickMainImageView.m
//  fanglian
//
//  Created by luobin on 2017/8/17.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "PickMainImageView.h"
//#import "AddLVImageView.h"

@implementation PickMainImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)addTheDeleteButton {
    
    self.userInteractionEnabled = YES;
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.bounds = CGRectMake(0, 0, 30, 30);
    deleteBtn.center = CGPointMake(_selfWidth - 10, 10);
    [deleteBtn setImage:[UIImage imageNamed:@"del_small_icon@2x"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self
                  action:@selector(deleteButtonIsPressed)
        forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:deleteBtn];
    
}


- (void)deleteButtonIsPressed {
//    [((AddLVImageView *)self.superview) deleteTheSelectImage:self];
    
    if (_delegate) {
        [_delegate deleteTheSelectImage:self];
    }
}

@end

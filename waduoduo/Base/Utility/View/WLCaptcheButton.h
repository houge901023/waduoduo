//
//  WLCaptcheButton.h
//  WLButtonCountingDownDemo
//
//  Created by wayne on 16/1/14.
//  Copyright © 2016年 ZHWAYNE. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface WLCaptcheButton : UIButton

@property (nonatomic, copy) IBInspectable NSString *identifyKey;
@property (nonatomic, strong) IBInspectable UIColor *disabledBackgroundColor;
@property (nonatomic, strong) IBInspectable UIColor *disabledTitleColor;

- (void)fire;

@end

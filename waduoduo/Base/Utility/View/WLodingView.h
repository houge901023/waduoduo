//
//  WLodingView.h
//  waduoduo
//
//  Created by Apple  on 2019/4/17.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WLodingView : UIView

+ (void)LodingData:(NSString *)Message;
+ (void)SenderData:(NSString *)Message;
+ (void)dismiss;

@end

NS_ASSUME_NONNULL_END

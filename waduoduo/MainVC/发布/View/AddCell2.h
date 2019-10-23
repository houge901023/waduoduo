//
//  AddCell2.h
//  waduoduo
//
//  Created by Apple  on 2019/7/22.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTTextView.h"
#import "AddModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddCell2 : UITableViewCell <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet WTTextView *introTV;

@property (nonatomic ,strong) AddModel *model;

@end

NS_ASSUME_NONNULL_END

//
//  AddCell1.h
//  waduoduo
//
//  Created by Apple  on 2019/7/22.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddCell1 : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UITextField *introTF;
@property (weak, nonatomic) IBOutlet UIImageView *jtImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *right;

@property (nonatomic ,strong) AddModel *model;

@end

NS_ASSUME_NONNULL_END

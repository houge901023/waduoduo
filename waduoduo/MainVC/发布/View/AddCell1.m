//
//  AddCell1.m
//  waduoduo
//
//  Created by Apple  on 2019/7/22.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import "AddCell1.h"
#import "AddProductVC.h"
#import "HZIAPManager.h"
#import "LQPopUpView.h"
#import "payInfoVC.h"

@interface AddCell1 ()

@property (nonatomic ,strong) AddModel *info;

@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
@property (nonatomic ,assign) NSInteger index;

@end

@implementation AddCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.introTF.delegate = self;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.introTF addTarget:self action:@selector(change) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(AddModel *)model {
    _model = model;
    self.info = model;
    
    if ([model.type isEqualToString:@"1"] || [model.type isEqualToString:@"6"]) {
        self.right.constant = 25;
        self.jtImg.hidden = NO;
        self.introTF.userInteractionEnabled = NO;
    }else {
        self.right.constant = 15;
        self.jtImg.hidden = YES;
        self.introTF.userInteractionEnabled = YES;
    }
    if ([model.title isEqualToString:@"联系电话"]) {
        self.eyeBtn.hidden = NO;
        self.introTF.keyboardType = UIKeyboardTypeNumberPad;
    }else {
        self.eyeBtn.hidden = YES;
        self.introTF.keyboardType = UIKeyboardTypeDefault;
    }
    self.titleLB.text = model.title;
    self.introTF.placeholder = model.placeHolder;
    self.introTF.text = model.intro;
}

- (void)change {
    self.model.intro = self.introTF.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}

- (IBAction)eyeAction:(UIButton *)sender {

    NSString *str = [AVUser currentUser][@"payCount"]; // 可用次数
    
    if (str.intValue>0) {
        if (sender.selected) {
            sender.selected = NO;
            [EasyTextView showText:@"已设置电话号码隐藏"];
            self.model.permissions = @"1";
        }else {
            sender.selected = YES;
            [EasyTextView showText:@"已设置电话号码显示"];
            self.model.permissions = @"2";
        }
    }else {
        
        AddProductVC *mm = (AddProductVC *)self.viewController;
        
        LQPopUpView *popUpView = [[LQPopUpView alloc] initWithTitle:@"提示" message:@"是否确定购买显示联系电话（以方便用户直接与你电话联系）"];
        [popUpView addBtnWithTitle:@"取消" type:LQPopUpBtnStyleCancel handler:^{
            
        }];
        [popUpView addBtnWithTitle:@"购买" type:LQPopUpBtnStyleDefault handler:^{
            mm.backView.hidden = NO;
            [EasyLoadingView showLoadingImage:@"正在获取中..."];
            [[HZIAPManager shareIAPManager] startIAPWithProductID:@"200010" completeHandle:^(IAPResultType type, NSData * _Nonnull data) {
                if (type == IAPResultVerSuccess || type == IAPResultSuccess) {
                    [self updatePay];
                }else {
                    mm.backView.hidden = YES;
                }
            }];
        }];
        [popUpView showInView:mm.view preferredStyle:LQPopUpViewStyleAlert];
        
        
    }
}

- (void)updatePay { // 存到后台
    
    self.index ++;
    AddProductVC *mm = (AddProductVC *)self.viewController;
    
    AVUser *user = [AVUser currentUser];
    [user setObject:@"1" forKey:@"payCount"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            mm.backView.hidden = YES;
            [EasyTextView showSuccessText:@"购买成功"];
        }else {
            if (self.index < 3) {
                [self updatePay];
            }else {
                mm.backView.hidden = YES;
                [EasyLoadingView hidenLoading];
                payInfoVC *MVC = [[payInfoVC alloc] init];
                MVC.isSuccess = 3;
                [mm.navigationController pushViewController:MVC animated:YES];
            }
        }
    }];
    
}

@end

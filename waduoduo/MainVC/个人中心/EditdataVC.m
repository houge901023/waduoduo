//
//  EditdataVC.m
//  waduoduo
//
//  Created by 名侯 on 2017/5/5.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import "EditdataVC.h"
#import "WTTextView.h"
#import "LucPhotoHelper.h"
#import "TWSelectCityView.h"

@interface EditdataVC () <UIActionSheetDelegate,LucPhotoHelperDelegate>
{
    UIImage *iconImage;
}
@property (strong, nonatomic) IBOutlet UIImageView *iconImg;
@property (strong, nonatomic) IBOutlet UITextField *companyTF;
@property (strong, nonatomic) IBOutlet UITextField *jobTF;
@property (strong, nonatomic) IBOutlet UITextField *modelTF;
@property (strong, nonatomic) IBOutlet UITextField *addressTF;
@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UIScrollView *mainTV;

@property (strong, nonatomic) IBOutlet UIView *backInfoV;
@property (strong, nonatomic) WTTextView *userinfoTF;
@property (strong, nonatomic) LucPhotoHelper *photoHelper;

@end

@implementation EditdataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"资料设置";
    [self configureRight:@"保存"];
    
    [self setup];
}

- (void)setup {
    
    _mainTV.contentSize = CGSizeMake(SCREEN_WIDTH, 100);
    [_iconImg setContentMode:UIViewContentModeScaleAspectFill];
    _iconImg.clipsToBounds = YES;
    [self setYuan:_iconImg size:30];
    _iconImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_iconImg addGestureRecognizer:tap];
    
    AVUser *user = [AVUser currentUser];
    
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:avoidNull([user[@"iconHead"] imgUrlUpdate])] placeholderImage:[UIImage imageNamed:@"my_icon"]];
    
    _nameTF.text = avoidNull(user.username);
    _companyTF.text = avoidNull(user[@"company"]);
    _jobTF.text = avoidNull(user[@"usertype"]);
    _modelTF.text = avoidNull(user[@"model"]);
    _addressTF.text = avoidNull(user[@"usercity"]);
    
    
    _userinfoTF = [[WTTextView alloc] initWithFrame:CGRectMake(15, 34, SCREEN_WIDTH-30, 74)];
    _userinfoTF.maxTextLength = 100;
    _userinfoTF.placeHolderTextColor = colorValue(0x999999, 1);
    _userinfoTF.placeHolder = @"请输入个人简介（最多100个字符）";
    _userinfoTF.textColor = titleC2;
    _userinfoTF.font = [UIFont systemFontOfSize:14];
    [_backInfoV addSubview:_userinfoTF];
    
    _userinfoTF.text = avoidNull(user[@"userinfo"]);
    
    //选择相册
    if (!_photoHelper) {
        //编辑头像
        _photoHelper = [[LucPhotoHelper alloc]init];
        _photoHelper.target = self;
        _photoHelper.delegate = self;
    }
    
}

#pragma mark -- UIImagePickerControllerDelegate (拍照)
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"方法1=%@",info);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    iconImage = portraitImg;
    _iconImg.image = iconImage;
    _iconImg.contentMode = UIViewContentModeScaleAspectFill;
    _iconImg.layer.masksToBounds = YES;
    //    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    // 保存图片至本地，方法见下文
}
#pragma mark -- 相册代理
- (void)LucPhotoHelperGetPhotoSuccess:(UIImage *)image {
    iconImage = image;
    _iconImg.image = iconImage;
}

#pragma mark -- 点击头像
- (void)tapAction {
    [_photoHelper editPortraitInView:self.view];
}

#pragma mark -- 右边点击事件
- (void)rightNavAction {
    if (_nameTF.text.length==0) {
        [SVProgressHUD showMessage:@"姓名不能为空"];
    }else if (_jobTF.text.length==0) {
        [SVProgressHUD showMessage:@"职业不能为空"];
    }else if (_addressTF.text.length==0) {
        [SVProgressHUD showMessage:@"所在地不能为空"];
    }else {
        if (iconImage) {
        
            NSData *data = UIImageJPEGRepresentation(iconImage, 0.001);
            AVFile *file = [AVFile fileWithData:data];
            [SVProgressHUD showWithStatus:@"上传中..."];
            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    [self request:file.url];
                }else {
                    [SVProgressHUD showErrorWithStatus:@"头像提交失败，稍后重试"];
                }
            }];
            
        }else {
            [self request:nil];
        }
    }
}

#pragma mark -- 修改个人信息请求
- (void)request:(NSString *)imgurl {
    
    AVUser *nuser = [AVUser currentUser];
    
    nuser.username = avoidNull(_nameTF.text);
    [nuser setObject:avoidNull(_companyTF.text) forKey:@"company"];
    [nuser setObject:avoidNull(_jobTF.text) forKey:@"usertype"];
    [nuser setObject:avoidNull(_modelTF.text) forKey:@"model"];
    [nuser setObject:avoidNull(_addressTF.text) forKey:@"usercity"];
    [nuser setObject:avoidNull(_userinfoTF.text) forKey:@"userinfo"];
    
    if (![XYString isObjectNull:imgurl]) {
        //删除之前头像
        if (![XYString isObjectNull:nuser[@"iconHead"]]) {
        
            NSLog(@"之前头像链接=%@",nuser[@"iconHead"]);
            AVQuery *query = [AVQuery queryWithClassName:@"_File"];
            [query whereKey:@"url" hasPrefix:nuser[@"iconHead"]];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if (objects.count) {
                    AVFile *file = objects[0];
                    [file deleteInBackground];
                }
            }];
        }
        [nuser setObject:imgurl forKey:@"iconHead"];
        NSLog(@"之后头像链接=%@",nuser[@"iconHead"]);
    }
    
    [nuser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            APP_DELE.refreshNum = 2;
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else {
            NSLog(@"失败信息=%@",error);
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"修改失败，%@",error.userInfo[@"error"]]];
        }
    }];
}

- (IBAction)jobAction {
    
    [self.view endEditing:YES];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"挖机用户",@"配件商户",@"维修工程师",@"挖机驾驶员",@"挖机行业", nil];
    [sheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==5) {
        
    }else {
        _jobTF.text = @[@"挖机用户",@"配件商户",@"维修工程师",@"挖机驾驶员",@"挖机行业"][buttonIndex];
    }
}


- (IBAction)cityAction {
    
    [self.view endEditing:YES];
    TWSelectCityView *city = [[TWSelectCityView alloc] initWithTWFrame:self.view.bounds TWselectCityTitle:@"选择地区"];
    [city showCityView:^(NSString *proviceStr, NSString *cityStr, NSString *distr) {
        _addressTF.text = [NSString stringWithFormat:@"%@%@%@",proviceStr,cityStr,distr];
        NSLog(@"%@",[NSString stringWithFormat:@"%@->%@->%@",proviceStr,cityStr,distr]);
    }];
    
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

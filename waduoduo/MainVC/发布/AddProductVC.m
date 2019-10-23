//
//  AddProductVC.m
//  waduoduo
//
//  Created by Apple  on 2019/7/22.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import "AddProductVC.h"
#import "AddModel.h"
#import "AddCell1.h"
#import "AddCell2.h"

#import "BaseChoseImageView.h"
#import "PreviewPhotoUseVC.h"
#import "WPhotoViewController.h"
#import "PickerView.h"

static NSString * const CellID1 = @"CellID1";
static NSString * const CellID2 = @"CellID2";
static NSString * const CellID3 = @"CellID3";
static NSString * const CellID4 = @"CellID4";

@interface AddProductVC () <UITableViewDelegate,UITableViewDataSource,BaseChoseImageViewDelegate,PickerViewResultDelegate>
{
    NSInteger indeximg; //图片数组下标
}

@property (nonatomic ,strong) NSMutableArray *dataArr;
@property (nonatomic ,strong) BaseChoseImageView *footView;
@property (nonatomic ,strong) UITableView *mainTV;
@property (nonatomic ,strong) NSMutableArray *imgurlArr;
@property (nonatomic ,strong) NSString *payCount;

@end

@implementation AddProductVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的供应";
    [self configureLeftImage:@"icon_back"];
    [self configureRight:@"发布"];
    
    [self setup];
}

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        NSString *indicatorsString =[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"gxsBaseinfo" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [indicatorsString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *indicators = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        _dataArr = [AddModel mj_objectArrayWithKeyValuesArray:indicators];
    }
    return _dataArr;
}

- (NSMutableArray *)imgurlArr {
    if (_imgurlArr==nil) {
        _imgurlArr = [NSMutableArray array];
    }
    return _imgurlArr;
}

- (BaseChoseImageView *)footView {
    if (_footView == nil) {
        _footView = [[BaseChoseImageView alloc] init];
        _footView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0);
        _footView.delegate = self;
        _footView.picNumber = 9;
        _footView.addTile.hidden = YES;
        _footView.addPicBtn.hidden = YES;
        _footView.backgroundColor = [UIColor clearColor];
        _footView.previewType = PreviewWithBigType;
    }
    return _footView;
}

- (void)backNavAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightNavAction {

    for (int i=0; i<6; i++) { // 条件筛查
        AddModel *model = self.dataArr[i];
        if (model.intro.length == 0) {
            [EasyTextView showText:@[@"请输入产品标题",
                                     @"请选择挖机品牌",
                                     @"请输入挖机型号",
                                     @"请选择产品质量",
                                     @"请输入产品价格",
                                     @"请选择产品分类"][i]];
            return;
        }
    }
    for (int i=7; i<9; i++) { // 条件筛查
        AddModel *model = self.dataArr[i];
        if (model.intro.length == 0) {
            [EasyTextView showText:@[@"请输入产品描述",
                                     @"请输入联系方式"][i-7]];
            return;
        }
        if (i==7) {
            
        }else {
            if ([NSString PhoneNumberMobile:model.intro] == NO) {
                return [EasyTextView showText:@"手机号不合法"];
            }
        }
    }
    if (self.footView.imageArray.count == 0) {
        [EasyTextView showText:@"请上传至少一张配件图片"];
    }else {
        [EasyLoadingView showLoadingImage:@"上传中..."];
        [self thePicture:self.footView.imageArray[0]];
    }
}

- (void)setup {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, JLNavH, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        tableView.estimatedRowHeight = 10;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.tableFooterView = self.footView;
    [self.view addSubview:tableView];
    self.mainTV = tableView;
    
    [tableView registerNib:[UINib nibWithNibName:@"AddCell1" bundle:nil] forCellReuseIdentifier:CellID1];
    [tableView registerNib:[UINib nibWithNibName:@"AddCell2" bundle:nil] forCellReuseIdentifier:CellID2];

    // 内购蒙版
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.backView.backgroundColor = UIColorWithRGBA(0, 0, 0, 0.3);
    self.backView.hidden = YES;
    [APP_DELE.window addSubview:self.backView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddModel *model = self.dataArr[indexPath.row];
    
    if ([model.type isEqualToString:@"3"]) {
        AddCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellID2];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AddCell2" owner:nil options:nil] firstObject];
        }
        
        cell.model = model;
        
        return cell;
    }else {
        AddCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellID1];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AddCell1" owner:nil options:nil] firstObject];
        }
        
        cell.model = model;
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddModel *model = self.dataArr[indexPath.row];
    if ([model.type isEqualToString:@"1"]) {
        [self.view endEditing:YES];
        PickerView *vi = [[PickerView alloc] init];
        vi.tag = 200+indexPath.row;
        vi.delegate = self;
        if ([model.title isEqualToString:@"挖机品牌"]) {
            [vi.array addObject:@[@"神钢",@"小松",@"卡特彼勒",@"日立",@"沃尔沃",
                                  @"凯斯",@"住友",@"斗山",@"现代",@"三一",@"徐工",
                                  @"柳工",@"龙工",@"玉柴",@"久保田",@"力士德",
                                  @"利勃海尔",@"山河智能",@"其它"]];
            vi.type = PickerViewTypeCustom;
        }else if ([model.title isEqualToString:@"产品质量"]) {
            [vi.array addObject:@[@"原装",@"副厂",@"拆车件",@"第二纯正",@"原装再生"]];
            vi.type = PickerViewTypeCustom;
        }else if ([model.title isEqualToString:@"产品分类"]) {
            [vi.array addObject:@[@"保养件",@"液压件",@"发动机配件",@"驾驶室配件",@"电器件",@"底盘件",@"整机",@"其他"]];
            vi.type = PickerViewTypeCustom;
        }
        [[UIApplication sharedApplication].keyWindow addSubview:vi];
    }
    
    if (indexPath.row == 9) {
        [self choseNewThingTwoThePicButtonPressed];
    }
}

-(void)pickerView:(UIView *)pickerView result:(NSString *)string{
    AddModel *model = self.dataArr[pickerView.tag-200];
    model.intro = string;
    [self.mainTV reloadData];
}

- (void)previewWithTheBigTypeAndThePicNumber:(NSInteger)pickNumber {
    PreviewPhotoUseVC *previewVC = [[PreviewPhotoUseVC alloc] init];
    previewVC.editImageChoice = self.footView;
    previewVC.startImage = pickNumber;
    [previewVC.imageArray addObjectsFromArray:self.footView.imageArray];
    
    //这里用导航栏推出的，预览视图的控制器的导航栏添加了删除按钮
    [self.navigationController pushViewController:previewVC animated:YES];
}

//选择要修改的图片
- (void)choseNewThingTwoThePicButtonPressed {
    //NSLog(@"相册");
    //选择多张图片
    WPhotoViewController *WphotoVC = [[WPhotoViewController alloc] init];
    //选择图片的最大数
    WphotoVC.selectPhotoOfMax = 9 - self.footView.imageArray.count;
    [WphotoVC setSelectPhotosBack:^(NSMutableArray *phostsArr) {
        for (int i = 0; i < phostsArr.count; i++) {
            UIImage *itemImage = [phostsArr[i] objectForKey:@"image"];
            [self.footView reloadAllitemSubviewswithImage:itemImage];
        }
        if (self.footView.imageArray.count>0 && self.footView.imageArray.count<4) {
            self.footView.height = ([UIScreen mainScreen].bounds.size.width - 52) / 3.0+20;
        }else if (self.footView.imageArray.count>6) {
            self.footView.height = ([UIScreen mainScreen].bounds.size.width - 52) +40;
        }else if (self.footView.imageArray.count == 0) {
            self.footView.height = 0;
        }else {
            self.footView.height = ([UIScreen mainScreen].bounds.size.width - 52) / 3.0*2+30;
        }
        self.mainTV.tableFooterView = self.footView;
    }];
    [self presentViewController:WphotoVC animated:YES completion:nil];
    
}

- (void)deleImg {
    
    if (self.footView.imageArray.count>0 && self.footView.imageArray.count<4) {
        self.footView.height = ([UIScreen mainScreen].bounds.size.width - 52) / 3.0+20;
    }else if (self.footView.imageArray.count>6) {
        self.footView.height = ([UIScreen mainScreen].bounds.size.width - 52) +40;
    }else if (self.footView.imageArray.count == 0) {
        self.footView.height = 0;
    }else {
        self.footView.height = ([UIScreen mainScreen].bounds.size.width - 52) / 3.0*2+30;
    }
    self.mainTV.tableFooterView = self.footView;
}

#pragma mark -- 上传图片
- (void)thePicture:(UIImage *)image {
    
    NSData *data = UIImageJPEGRepresentation(image, 0.001);
    AVFile *file = [AVFile fileWithData:data];
    
    indeximg ++;
    
    [file uploadWithCompletionHandler:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [self.imgurlArr addObject:file.url];
            if (indeximg == self.footView.imageArray.count) {
                [self request];
            }else {
                [self thePicture:self.footView.imageArray[indeximg]];
            }
        }else {
            //            AVQuery *query = [AVQuery queryWithClassName:@"_File"];
            //            [query whereKey:@"url" containedIn:self.imgurlArr];
            //            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            //                if (objects.count) {
            //                    for (AVFile *file in objects) {
            //                        [file deleteInBackground];
            //                    }
            //                }
            //            }];
            [self.imgurlArr removeAllObjects];
            [EasyTextView showErrorText:@"上传失败，稍后重试"];
        }
    }];
}

#pragma mark -- 提交的网络请求
- (void)request {
    
    AVObject *product = [AVObject objectWithClassName:@"Supply"];
    for (int i=0; i<9; i++) {
        AddModel *model = self.dataArr[i];
        [product setObject:avoidNull(model.intro) forKey:@[@"title",
                                                           @"brand",
                                                           @"model",
                                                           @"quality",
                                                           @"price",
                                                           @"class",
                                                           @"partsNum",
                                                           @"content",
                                                           @"phone",
                                                           ][i]];
    }
    [product setObject:[self.imgurlArr componentsJoinedByString:@","] forKey:@"image"];
    AddModel *model = self.dataArr[8];
    [product setObject:model.permissions forKey:@"permissions"]; // 电话权限
    [product setObject:[[NSDate date] string] forKey:@"date"];
    [product setObject:[AVUser currentUser] forKey:@"owner"];
    [product setObject:[AVUser currentUser].objectId forKey:@"userId"];
    
    [product saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [EasyTextView showSuccessText:@"上传成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            AddModel *model = self.dataArr[8];
            if ([model.permissions isEqualToString:@"2"]) { // 成功后清除数量
                
                AVUser *user = [AVUser currentUser];
                [user setObject:@"0" forKey:@"payCount"];
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        
                    }else {
                        
                    }
                }];
            }
        } else {
            [EasyTextView showErrorText:@"上传失败，稍后重试"];
        }
    }];
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

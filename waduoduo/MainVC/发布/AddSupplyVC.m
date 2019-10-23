//
//  AddSupplyVC.m
//  waduoduo
//
//  Created by 名侯 on 2017/5/8.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import "AddSupplyVC.h"
#import "WTTextView.h"
#import "LTPickerView.h"

@interface AddSupplyVC () <LQPhotoPickerViewDelegate,UITextViewDelegate>
{
    //备注文本View高度
    float noteTextHeight;
    
    float pickerViewHeight;
    float allViewHeight;
    
    NSInteger indeximg;//图片数组下标
    NSString *lable;//标签
}

@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) UIView *noteTextBackgroudView;
//备注
@property(nonatomic,strong) WTTextView *noteTextView;

//文字个数提示label
@property(nonatomic,strong) UILabel *textNumberLabel;

//文字说明
@property(nonatomic,strong) UILabel *explainLabel;

//提交按钮
@property(nonatomic,strong) UIButton *submitBtn;

@property(nonatomic,strong) NSMutableArray *imgurlArr;

@property (strong, nonatomic) LTPickerView* pickerView;

@end

@implementation AddSupplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的供应";
    [self configureRight:@"关闭"];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, JLNavH, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.bounces = YES;
    _scrollView.scrollEnabled = YES;
    [self.view addSubview:_scrollView];
    
    //收起键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    
    /**
     *  依次设置
     */
    self.LQPhotoPicker_superView = _scrollView;
    
    self.LQPhotoPicker_imgMaxCount = 9;
    
    [self LQPhotoPicker_initPickerView];
    
    self.LQPhotoPicker_delegate = self;
    
    [self initViews];
}

- (NSMutableArray *)imgurlArr {
    if (_imgurlArr==nil) {
        _imgurlArr = [NSMutableArray array];
    }
    return _imgurlArr;
}

- (void)viewTapped{
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"caseLogNeedRef" object:nil];
}

- (void)initViews{
    
    self.pickerView = [LTPickerView new];
    
    UIView *parameterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    [_scrollView addSubview:parameterView];
    
    UITextField *nameTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 25, SCREEN_WIDTH-30, 30)];
    nameTF.placeholder = @"请输入配件名称";
    nameTF.tag = 1999;
    nameTF.textColor = titleC2;
    nameTF.font = [UIFont boldSystemFontOfSize:14];
    [parameterView addSubview:nameTF];
    
    CGFloat w = (SCREEN_WIDTH-105)/2;
    
    for (int i=0; i<3; i++) {
        
        //名称
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 60+i*30, 80, 30)];
        titleLB.text = @[@"挖机品牌：",@"配件质量：",@"配件分类："][i];
        titleLB.textColor = titleC1;
        titleLB.font = [UIFont systemFontOfSize:14];
        [parameterView addSubview:titleLB];
        
        UITextField *seleTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 60+i*30, w, 30)];
        seleTF.placeholder = @"请选择";
        seleTF.tag = 2000+i;
        seleTF.textColor = titleC2;
        seleTF.font = [UIFont systemFontOfSize:14];
        [parameterView addSubview:seleTF];
        
        UITextField *valueTF = [[UITextField alloc] initWithFrame:CGRectMake(90+w, 60+i*30, w, 30)];
        valueTF.placeholder = @[@"请输入挖机型号",@"请输入价格",@"请输入配件编号"][i];
        valueTF.textColor = titleC2;
        valueTF.tag = 3000+i;
        if (i==0) valueTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        if (i==1) valueTF.keyboardType = UIKeyboardTypeNumberPad;
        if (i==2) valueTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        valueTF.font = [UIFont systemFontOfSize:14];
        [parameterView addSubview:valueTF];
        
        UIButton *seleBtn = [[UIButton alloc] initWithFrame:CGRectMake(90, 60+i*30, w, 30)];
        seleBtn.tag = 1000+i;
        [seleBtn addTarget:self action:@selector(seleAction:) forControlEvents:UIControlEventTouchUpInside];
        [parameterView addSubview:seleBtn];
    }
    
    _noteTextBackgroudView = [[UIView alloc]init];
    //    _noteTextBackgroudView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    _noteTextView.backgroundColor = [UIColor blueColor];
    
    _noteTextView = [[WTTextView alloc]init];
    _noteTextView.placeHolder = @"请输入配件详细信息（不可带有联系方式）";
    _noteTextView.placeHolderTextColor = colorValue(0xcccccc, 1);
    _noteTextView.disabelEmoji = YES;
    _noteTextView.textColor = colorValue(0x666666, 1);
    _noteTextView.delegate = self;
    _noteTextView.font = [UIFont systemFontOfSize:14];
    
    _textNumberLabel = [[UILabel alloc]init];
    _textNumberLabel.textAlignment = NSTextAlignmentRight;
    _textNumberLabel.font = [UIFont boldSystemFontOfSize:12];
    _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    _textNumberLabel.backgroundColor = [UIColor whiteColor];
    _textNumberLabel.text = @"0/300    ";
    
    _explainLabel = [[UILabel alloc]init];
    _explainLabel.text = @"添加图片不超过9张，第1张为主图";
    _explainLabel.textColor = colorValue(0x999999, 1);
    _explainLabel.textAlignment = NSTextAlignmentCenter;
    _explainLabel.font = [UIFont boldSystemFontOfSize:12];
    
    _submitBtn = [[UIButton alloc]init];
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:155.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [_submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:_noteTextBackgroudView];
    [_scrollView addSubview:_noteTextView];
    [_scrollView addSubview:_textNumberLabel];
    [_scrollView addSubview:_explainLabel];
    [_scrollView addSubview:_submitBtn];
}

#pragma mark -- 布局控件
- (void)updateViewsFrame{
    
    if (!allViewHeight) {
        allViewHeight = 0;
    }
    if (!noteTextHeight) {
        noteTextHeight = 100;
    }
    
    _noteTextBackgroudView.frame = CGRectMake(0, 160, SCREEN_WIDTH, noteTextHeight);
    
    //文本编辑框
    _noteTextView.frame = CGRectMake(15, 160, SCREEN_WIDTH-30, noteTextHeight);
    
    
    //文字个数提示Label
    _textNumberLabel.frame = CGRectMake(0, _noteTextView.frame.origin.y + _noteTextView.frame.size.height-15, SCREEN_WIDTH-10, 15);
    
    
    //photoPicker
    [self LQPhotoPicker_updatePickerViewFrameY:_textNumberLabel.frame.origin.y + _textNumberLabel.frame.size.height];
    
    
    //说明文字
    _explainLabel.frame = CGRectMake(0, [self LQPhotoPicker_getPickerViewFrame].origin.y+[self LQPhotoPicker_getPickerViewFrame].size.height+10, SCREEN_WIDTH, 20);
    
    
    //提交按钮
    _submitBtn.bounds = CGRectMake(10, _explainLabel.frame.origin.y+_explainLabel.frame.size.height +30, SCREEN_WIDTH -20, 40);
    _submitBtn.frame = CGRectMake(10, _explainLabel.frame.origin.y+_explainLabel.frame.size.height +30, SCREEN_WIDTH -20, 40);
    
    
    allViewHeight = noteTextHeight + [self LQPhotoPicker_getPickerViewFrame].size.height + 30 + 100;
    
    _scrollView.contentSize = self.scrollView.contentSize = CGSizeMake(0,allViewHeight+160);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/300    ",(unsigned long)_noteTextView.text.length];
    if (_noteTextView.text.length > 300) {
        _textNumberLabel.textColor = [UIColor redColor];
    }
    else{
        _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    
    [self textChanged];
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/300    ",(unsigned long)_noteTextView.text.length];
    if (_noteTextView.text.length > 300) {
        _textNumberLabel.textColor = [UIColor redColor];
    }
    else{
        _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    [self textChanged];
}

-(void)textChanged{
    
    CGRect orgRect = self.noteTextView.frame;//获取原始UITextView的frame
    
    CGSize size = [self.noteTextView sizeThatFits:CGSizeMake(self.noteTextView.frame.size.width, MAXFLOAT)];
    
    orgRect.size.height=size.height+10;//获取自适应文本内容高度
    
    if (orgRect.size.height > 100) {
        noteTextHeight = orgRect.size.height;
    }
    [self updateViewsFrame];
}

#pragma mark -- 提交的点击事件
- (void)submitBtnClicked{
    
    NSArray *imgArr = [self LQPhotoPicker_getBigImageArray];
    
    UITextField *nameTF = (UITextField *)[_scrollView viewWithTag:1999];
    UITextField *brandTF = (UITextField *)[_scrollView viewWithTag:2000];
    UITextField *qualityTF = (UITextField *)[_scrollView viewWithTag:2001];
    UITextField *classTF = (UITextField *)[_scrollView viewWithTag:2002];
    UITextField *modelTF = (UITextField *)[_scrollView viewWithTag:3000];
    UITextField *priceTF = (UITextField *)[_scrollView viewWithTag:3001];
    
    if (nameTF.text.length==0) {
        [EasyTextView showText:@"请输入配件名称"]; return;
    }else if (brandTF.text.length==0) {
        [EasyTextView showText:@"请选择挖机品牌"]; return;
    }else if (qualityTF.text.length==0) {
        [EasyTextView showText:@"请选择配件质量"]; return;
    }else if (classTF.text.length==0) {
        [EasyTextView showText:@"请选择配件分类"]; return;
    }else if (priceTF.text.length==0) {
        [EasyTextView showText:@"请输入配件价格"]; return;
    }else if (modelTF.text.length==0) {
        [EasyTextView showText:@"请输入挖机型号"]; return;
    }else if (_noteTextView.text.length==0) {
        [EasyTextView showText:@"请输入配件详细信息"]; return;
    }else if (imgArr.count==0) {
        [EasyTextView showText:@"请上传至少一张配件图片"]; return;
    }else {
        
        [EasyLoadingView showLoadingImage:@"上传中..."];
        [self thePicture:imgArr[0]];
    }
    
}

#pragma maek - 检查输入
- (BOOL)checkInput{
    if (_noteTextView.text.length == 0) {
        //MBhudText(self.view, @"请添加记录备注", 1);
        return NO;
    }
    return YES;
}

- (void)LQPhotoPicker_pickerViewFrameChanged{
    [self updateViewsFrame];
}

- (void)rightNavAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)seleAction:(UIButton *)sender {
    
    if (sender.tag==1000) {
        self.pickerView.dataSource = @[@"神钢",@"小松",@"卡特彼勒",@"日立",@"沃尔沃",
                                       @"凯斯",@"住友",@"斗山",@"现代",@"三一",@"徐工",
                                       @"柳工",@"龙工",@"玉柴",@"久保田",@"力士德",
                                       @"利勃海尔",@"山河智能",@"其它"];
    }else if (sender.tag==1001){
        self.pickerView.dataSource = @[@"原装",@"副厂",@"拆车件",@"第二纯正",@"原装再生"];
    }else {
        self.pickerView.dataSource = @[@"保养件",@"液压件",@"发动机配件",@"驾驶室配件",@"电器件",@"底盘件",@"整机",@"其他"];
    }
    
    UITextField *textTF = (UITextField *)[_scrollView viewWithTag:1000+sender.tag];
    
    [self.pickerView show];//显示
    //回调block
    self.pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
        //obj:LTPickerView对象
        //str:选中的字符串
        //num:选中了第几行
        textTF.text = str;
    };
}

#pragma mark -- 上传图片
- (void)thePicture:(UIImage *)image {
    
    NSData *data = UIImageJPEGRepresentation(image, 0.001);
    AVFile *file = [AVFile fileWithData:data];
    
    indeximg ++;
    
    [file uploadWithCompletionHandler:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [self.imgurlArr addObject:file.url];
            if (indeximg==[self LQPhotoPicker_getBigImageArray].count) {
                [self request];
            }else {
                [self thePicture:[self LQPhotoPicker_getBigImageArray][indeximg]];
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

    UITextField *nameTF = (UITextField *)[_scrollView viewWithTag:1999];
    UITextField *brandTF = (UITextField *)[_scrollView viewWithTag:2000];
    UITextField *qualityTF = (UITextField *)[_scrollView viewWithTag:2001];
    UITextField *classTF = (UITextField *)[_scrollView viewWithTag:2002];
    UITextField *modelTF = (UITextField *)[_scrollView viewWithTag:3000];
    UITextField *priceTF = (UITextField *)[_scrollView viewWithTag:3001];
    UITextField *partsNumTF = (UITextField *)[_scrollView viewWithTag:3002];
    
    AVObject *product = [AVObject objectWithClassName:@"Supply"];
    
    [product setObject:avoidNull(nameTF.text) forKey:@"title"];
    [product setObject:avoidNull(qualityTF.text) forKey:@"quality"];
    [product setObject:avoidNull(classTF.text) forKey:@"class"];
    [product setObject:avoidNull(priceTF.text) forKey:@"price"];
    [product setObject:avoidNull(modelTF.text) forKey:@"model"];
    [product setObject:avoidNull(brandTF.text) forKey:@"brand"];
    [product setObject:avoidNull(partsNumTF.text) forKey:@"partsNum"];
    
    [product setObject:avoidNull(_noteTextView.text) forKey:@"content"];
    [product setObject:[self.imgurlArr componentsJoinedByString:@","] forKey:@"image"];
    [product setObject:[[NSDate date] string] forKey:@"date"];
    [product setObject:[AVUser currentUser] forKey:@"owner"];
    [product setObject:[AVUser currentUser].objectId forKey:@"userId"];
    
    [product saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [EasyTextView showSuccessText:@"上传成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
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

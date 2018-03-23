//
//  AdddemandVC.m
//  waduoduo
//
//  Created by 名侯 on 2017/5/3.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import "AdddemandVC.h"
#import "WTTextView.h"
#import "VOTagList.h"

@interface AdddemandVC () <LQPhotoPickerViewDelegate>
{
    //备注文本View高度
    float noteTextHeight;
    
    float pickerViewHeight;
    float allViewHeight;
    
    float tagH;//标签栏高度
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

@property(nonatomic,strong) VOTagList *tagList;

@property(nonatomic,strong) NSMutableArray *imgurlArr;

@end

@implementation AdddemandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的求购";
    [self configureRight:@"关闭"];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
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
    
    NSArray *tags = @[@"原装配件", @"副厂",@"拆车件", @"维修",@"挖机驾驶员",@"二手挖机",@"工地",@"挖机出租"];
    _tagList = [[VOTagList alloc] initWithTags:tags];
    _tagList.frame = CGRectMake(15, 15, SCREEN_WIDTH-30, 200);
    _tagList.font = [UIFont systemFontOfSize:14];
    _tagList.multiLine = YES;
    _tagList.multiSelect = NO;
    _tagList.allowNoSelection = YES;
    _tagList.vertSpacing = 10;
    _tagList.horiSpacing = 10;
    _tagList.textColor = [UIColor whiteColor];
    _tagList.selectedTextColor = [UIColor whiteColor];
    _tagList.tagBackgroundColor = colorValue(0xcccccc, 1);
    _tagList.selectedTagBackgroundColor = mainBlue;
    _tagList.tagCornerRadius = 3;
    _tagList.tagEdge = UIEdgeInsetsMake(4, 8, 6, 8);
    [_tagList addTarget:self action:@selector(selectedTagsChanged:) forControlEvents:UIControlEventValueChanged];
    [_scrollView addSubview:_tagList];
    
    _noteTextBackgroudView = [[UIView alloc]init];
    //    _noteTextBackgroudView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    _noteTextView.backgroundColor = [UIColor blueColor];
    
    _noteTextView = [[WTTextView alloc]init];
    _noteTextView.placeHolder = @"请输入你具体想要什么...";
    _noteTextView.placeHolderTextColor = colorValue(0xcccccc, 1);
    _noteTextView.disabelEmoji = YES;
    _noteTextView.textColor = colorValue(0x666666, 1);
    _noteTextView.delegate = self;
    _noteTextView.font = [UIFont boldSystemFontOfSize:14];
    
    _textNumberLabel = [[UILabel alloc]init];
    _textNumberLabel.textAlignment = NSTextAlignmentRight;
    _textNumberLabel.font = [UIFont boldSystemFontOfSize:12];
    _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    _textNumberLabel.backgroundColor = [UIColor whiteColor];
    _textNumberLabel.text = @"0/300    ";
    
    _explainLabel = [[UILabel alloc]init];
    _explainLabel.text = @"标签最多选择1个，添加图片不超过9张";
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
    
    DefineWeakSelf;
    [_tagList setTagsH:^(CGFloat h) {
        weakSelf.tagList.height = h;
        tagH = h+30;
        [weakSelf updateViewsFrame];
    }];
}

#pragma mark -- 布局控件
- (void)updateViewsFrame{
    
    if (!allViewHeight) {
        allViewHeight = 0;
    }
    if (!noteTextHeight) {
        noteTextHeight = 100;
    }
    
    _noteTextBackgroudView.frame = CGRectMake(0, tagH, SCREEN_WIDTH, noteTextHeight);
    
    //文本编辑框
    _noteTextView.frame = CGRectMake(15, tagH, SCREEN_WIDTH - 30, noteTextHeight);
    
    
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
    
    _scrollView.contentSize = self.scrollView.contentSize = CGSizeMake(0,allViewHeight+tagH);
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
    
    if (_noteTextView.text.length==0) {
        [SVProgressHUD showMessage:@"输入内容不能为空"];
    }else {
        NSArray *imgArr = [self LQPhotoPicker_getBigImageArray];
        [SVProgressHUD showWithStatus:@"上传中..."];
        if (imgArr.count) {
            [self thePicture:imgArr[0]];
        }else {
            [self request];
        }
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

- (void)selectedTagsChanged:(VOTagList *)tagList{
    NSInteger tag = tagList.selectedIndexSet.firstIndex;
    if (tag<8) {
        lable = @[@"原装配件1", @"副厂1",@"拆车件1",@"维修2",@"挖机驾驶员2", @"二手挖机3",@"工地3",@"挖机出租3"][tag];
    }else {
        lable = @"";
    }
}

- (void)rightNavAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- 上传图片
- (void)thePicture:(UIImage *)image {
    
    NSData *data = UIImageJPEGRepresentation(image, 0.001);
    AVFile *file = [AVFile fileWithData:data];
    
    indeximg ++;
    
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [self.imgurlArr addObject:file.url];
            if (indeximg==[self LQPhotoPicker_getBigImageArray].count) {
                [self request];
            }else {
                [self thePicture:[self LQPhotoPicker_getBigImageArray][indeximg]];
            }
        }else {
            
            AVQuery *query = [AVQuery queryWithClassName:@"_File"];
            [query whereKey:@"url" containedIn:self.imgurlArr];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if (objects.count) {
                    for (AVFile *file in objects) {
                        [file deleteInBackground];
                    }
                }
            }];
            [self.imgurlArr removeAllObjects];
            [SVProgressHUD showErrorWithStatus:@"上传失败，稍后重试"];
        }
    }];
}

#pragma mark -- 提交的网络请求
- (void)request {
    
    AVObject *product = [AVObject objectWithClassName:@"Demand"];
    [product setObject:avoidNull(_noteTextView.text) forKey:@"content"];
    [product setObject:avoidNull(lable) forKey:@"lable"];
    [product setObject:[[NSDate date] string] forKey:@"date"];
    
    [product setObject:[AVUser currentUser] forKey:@"owner"];
    [product setObject:[AVUser currentUser].objectId forKey:@"userId"];
    
    if (self.imgurlArr.count) {
        [product setObject:[self.imgurlArr componentsJoinedByString:@","] forKey:@"image"];
    }
    
    [product saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:@"上传失败，稍后重试"];
        }
    }];
}

@end

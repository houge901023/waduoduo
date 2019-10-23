//
//  PreviewPhotoUseVC.m
//  fanglian
//
//  Created by luobin on 2018/4/16.
//  Copyright © 2018年 Admin. All rights reserved.
//

#import "PreviewPhotoUseVC.h"
#import "AlbumItem.h"
#import "BaseChoseImageView.h"

#define ScreenBounds    (UIScreen.mainScreen.bounds)
#define ScreenWidth     (ScreenBounds.size.width)
#define ScreenHeight    (ScreenBounds.size.height)
#define navigationHeight (([UIScreen mainScreen].bounds.size.height-64)/504)
#define StatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define NavigationBarHeight (self.navigationController.navigationBar.bounds.size.height)

@interface PreviewPhotoUseVC () <UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView *backScrollView;//主容器图
@property (nonatomic, strong)NSMutableArray *subViewsArray;//子视图集合

@property (nonatomic, strong)UILabel *picNumberLab;

@end

@implementation PreviewPhotoUseVC

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeBaseViewDataResource];
    [self initializeBaseViewUserInterface];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBar.barTintColor = RGBACOLOR(34, 34, 34, 1);
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:16], NSForegroundColorAttributeName:[UIColor whiteColor]}];
//
//    //影藏导航栏下面的横线
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    NSLog(@"---%f",_backScrollView.frame.size.height);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBar.barTintColor = RGBACOLOR(255, 255, 255, 1);
//    self.navigationController.navigationBar.tintColor = RGBACOLOR(45, 45, 45, 1);
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:16], NSForegroundColorAttributeName: RGBACOLOR(45, 45, 45, 1)}];
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"navigationItem_left_close_icon"]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _backScrollView.frame = CGRectMake(0, 0, ScreenWidth, self.view.bounds.size.height);
}

- (void)initializeBaseViewDataResource {
    
}

- (void)initializeBaseViewUserInterface {
    
    self.title = @"预览";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self defineTheBackButtonBySelfwithImage:@"navigation_back@2x.png"];
    
    if (_editImageChoice || _delegate) {
        //右上角的删除按钮
        UIImage *addImage = [UIImage imageNamed:@"del_small_icon@2x"];
        UIImage *lastnor = [addImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *delItemButton = [[UIBarButtonItem alloc] initWithImage:lastnor
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(deleteTheCurrentImage)];
        self.navigationItem.rightBarButtonItem = delItemButton;
        
        _subViewsArray = [[NSMutableArray alloc] init];
    }
    
    _backScrollView = [[UIScrollView alloc] init];
    _backScrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight - StatusBarHeight - 20);
    _backScrollView.contentSize = CGSizeMake(ScreenWidth * _imageArray.count, ScreenHeight - navigationHeight - StatusBarHeight - 20);
    _backScrollView.pagingEnabled = YES;
    _backScrollView.delegate = self;
    
    [self.view addSubview:_backScrollView];
    
    for (int i = 0; i < _imageArray.count; i++) {
        AlbumItem *imageItem = [[AlbumItem alloc] init];
        imageItem.frame = CGRectMake(i * ScreenWidth, 0, ScreenWidth, ScreenHeight - navigationHeight - StatusBarHeight - 20);
        imageItem.tag = 500 + i;
        imageItem.contentSize = CGSizeMake(ScreenWidth, ScreenHeight - navigationHeight - StatusBarHeight - 20);
        imageItem.itemHeight = ScreenHeight - navigationHeight - StatusBarHeight - 20;
        [imageItem addTheImageViewWithItemImage:_imageArray[i]];

        [_backScrollView addSubview:imageItem];
        
        [_subViewsArray addObject:imageItem];
    }
    
    if (_startImage > 0) {
        _backScrollView.contentOffset = CGPointMake(ScreenWidth * _startImage, 0);
    }

    _picNumberLab = [[UILabel alloc] init];
    _picNumberLab.backgroundColor = [UIColor clearColor];
    _picNumberLab.textColor = [UIColor whiteColor];
    _picNumberLab.textAlignment = NSTextAlignmentCenter;
    _picNumberLab.bounds = CGRectMake(0, 0, 120, 24);
    _picNumberLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    _picNumberLab.text = [NSString stringWithFormat:@"%ld/%ld", _startImage + 1, _imageArray.count];
    _picNumberLab.center = CGPointMake(ScreenWidth * 0.5, ScreenHeight - navigationHeight - StatusBarHeight - 10);
    
    [self.view addSubview:_picNumberLab];
    
}

//重新排列图片的展示
- (void)reloadAllPicturesPosition {
    
    NSInteger delNumber = _backScrollView.contentOffset.x / ScreenWidth;
    
    AlbumItem *delItem = _subViewsArray[delNumber];
    
    [delItem removeFromSuperview];
    [_subViewsArray removeObjectAtIndex:delNumber];
    [_imageArray removeObjectAtIndex:delNumber];
    [_editImageChoice deleteThePictureWithTheCountNumber:delNumber];
    if ([_delegate respondsToSelector:@selector(deletePhotoAndRefresh:)]) {
        [_delegate deletePhotoAndRefresh:delNumber];
    }
    
    for (int i = 0; i < _subViewsArray.count; i++) {
        AlbumItem *imageItem = _subViewsArray[i];
        
        imageItem.center = CGPointMake(ScreenWidth * 0.5 + ScreenWidth * i, (ScreenHeight - navigationHeight - StatusBarHeight - 20) * 0.5);
    }
    
    _backScrollView.contentSize = CGSizeMake(ScreenWidth * _subViewsArray.count, ScreenHeight - navigationHeight - StatusBarHeight - 20);
    
    NSInteger currentPic = _backScrollView.contentOffset.x / ScreenWidth;
    _picNumberLab.text = [NSString stringWithFormat:@"%ld/%ld", currentPic + 1, _imageArray.count];
    
    if (_subViewsArray.count <= 0) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)deleteTheCurrentImage {
    
    [self reloadAllPicturesPosition];
    
}

#pragma mark -滚动代理:减速完毕后调用（停止了）------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPic = _backScrollView.contentOffset.x / ScreenWidth;
    _picNumberLab.text = [NSString stringWithFormat:@"%ld/%ld", currentPic + 1, _imageArray.count];
}



@end

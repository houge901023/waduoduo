//
//  PartsVC.m
//  waduoduo
//
//  Created by 名侯 on 2017/4/20.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import "PartsVC.h"
#import "shopsCell.h"
#import "MJRefresh.h"
#import <UIImageView+WebCache.h>
#import "PartsDetailsVC.h"
//第一步，导入头文件
#import "NewEditionTestManager.h"
#import "AppStoreInfoModel.h"

static NSString * CellIdentifier = @"CellIdentifier";

@interface PartsVC ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UIView *dropBackV;
    UITableView *dropV;
    UIView *_titleV;
    NSArray *modelsArr;
    NSArray *classArr;
    BOOL staBtn;
    //布局商品
    UICollectionView *mainCollectionView;
    int page;
    NSString *modelStr;
    NSString *classStr;
}

@property (nonatomic ,strong) UIButton *imgNil;
@property (strong, nonatomic) NSMutableArray *products;

@end

@implementation PartsVC

- (NSMutableArray *)products {
    if (_products == nil) {
        _products = [NSMutableArray array];
    }
    return _products;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUICollectionView];
    [self setdropdownView];
    [self setTitleView];
    [self request];
//    [self newGuidelines];
    
    //第二步  appID:应用在Store里面的ID (应用的AppStore地址里面可获取)
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [NewEditionTestManager checkNewEditionWithAppID:@"1187841637" CustomAlert:^(AppStoreInfoModel *appInfo) {
        
        if ([app_Version isEqualToString:appInfo.version] ) {
            APP_DELE.newV = YES;
            NSLog(@"最新版本号=%@",appInfo.version);
        }else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"有新的版本(%@)",appInfo.version] message:appInfo.releaseNotes preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"立即升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1187841637"]]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1187841637"] options:@{} completionHandler:nil];
                }
                NSLog(@"链接=%@",appInfo.trackViewUrl);
            }];
            UIAlertAction *delayAction = [UIAlertAction actionWithTitle:@"稍后再说" style:UIAlertActionStyleDefault handler:nil];
            
            [alertController addAction:updateAction];
            [alertController addAction:delayAction];
            [self presentViewController:alertController animated:YES completion:nil];
            APP_DELE.newV = NO;
        }
    }];//2种用法,自定义Alert
}

#pragma mark -- 新手指引
- (void)newGuidelines {
    
    //蒙版
    UIView *GuidelinesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    GuidelinesView.backgroundColor = color(0, 0, 0, 0.6);
    [APP_DELE.window addSubview:GuidelinesView];
    
    UITapGestureRecognizer *GuidelinesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GuidelinesDismm:)];
    [GuidelinesView addGestureRecognizer:GuidelinesTap];
    
    //构建显示区域（添加一个路径）
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:[UIScreen mainScreen].bounds];
    // 这里添加第二个路径 （这个是圆）
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(SCREEN_WIDTH - 30, 42) radius:30 startAngle:0 endAngle:2*M_PI clockwise:NO]];
    //创建矩形区域
//    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(SCREEN_WIDTH/2.0-1, 234, SCREEN_WIDTH/2.0+1, 55) cornerRadius:5] bezierPathByReversingPath]];

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [GuidelinesView.layer setMask:shapeLayer];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    APP_DELE.refreshNum = 0;
}

#pragma mark -- 设置标题栏选项
- (void)setTitleView {
    
    modelStr = @"挖机品牌";
    classStr = @"配件分类";
    
    UIView *titleV = [[UIView alloc] initWithFrame:CGRectMake(0, JLNavH, SCREEN_WIDTH, 40)];
    titleV.backgroundColor = [UIColor whiteColor];
    [self PixeH:CGPointMake(0, 39) lenght:SCREEN_WIDTH add:titleV];
    [self PixeV:CGPointMake(SCREEN_WIDTH/2, 7) lenght:26 add:titleV];
    _titleV = titleV;
    [self.view addSubview:titleV];
    
    for (int i=0; i<2; i++) {
        
        //布局状态选项
        UIButton *stausBT = [[UIButton alloc] initWithFrame:CGRectMake(12+i*SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2-24, 40)];
        stausBT.titleLabel.font = [UIFont systemFontOfSize:14];
        stausBT.tag = 1000+i;
        [stausBT setTitle:@[@"挖机品牌",@"配件分类"][i] forState:UIControlStateNormal];
        [stausBT setTitleColor:colorValue(0x333333, 1) forState:UIControlStateNormal];
        [stausBT setTitleColor:mainBlue forState:UIControlStateSelected];
        [stausBT setImage:[UIImage imageNamed:@"jiantou_2"] forState:UIControlStateNormal];
        [stausBT setImage:[UIImage imageNamed:@"jiantou_1"] forState:UIControlStateSelected];
        [stausBT addTarget:self action:@selector(stauseAction:) forControlEvents:UIControlEventTouchUpInside];
        //
        CGFloat w = [XYString WidthForString:@[@"挖机品牌",@"配件分类"][i] withSizeOfFont:14]+2;
        [stausBT setTitleEdgeInsets:UIEdgeInsetsMake(0, -14, 0, 14)];
        [stausBT setImageEdgeInsets:UIEdgeInsetsMake(0, w, 0, -w)];
        [titleV addSubview:stausBT];
    }
    
}
#pragma mark -- 下拉tableView
- (void)setdropdownView {
    
    _imgNil = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    _imgNil.hidden = YES;
    _imgNil.userInteractionEnabled = NO;
    _imgNil.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [_imgNil setImage:[UIImage imageNamed:@"data_nil"] forState:UIControlStateNormal];
    [_imgNil setTitle:@"空，快去发布～" forState:UIControlStateNormal];
    [_imgNil setTitleColor:titleC3 forState:UIControlStateNormal];
    _imgNil.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_imgNil];
    
    CGFloat w = [XYString WidthForString:@"空，快去发布～" withSizeOfFont:12];
    [_imgNil setTitleEdgeInsets:UIEdgeInsetsMake(60, 0, 0, 80)];
    [_imgNil setImageEdgeInsets:UIEdgeInsetsMake(0, w, 40, 0)];
    
    modelsArr = @[@"全部",@"神钢",@"小松",@"卡特彼勒",@"日立",@"沃尔沃",
                  @"凯斯",@"住友",@"斗山",@"现代",@"三一",@"徐工",
                  @"柳工",@"龙工",@"玉柴",@"久保田",@"力士德",
                  @"利勃海尔",@"山河智能",@"其它"];
    classArr = @[@"全部",@"保养件",@"液压件",@"发动机配件",@"驾驶室配件",@"电器件",@"底盘件",@"其他"];
    
    dropBackV = [[UIView alloc] initWithFrame:CGRectMake(0, 35+JLNavH, SCREEN_WIDTH, SCREEN_HEIGHT-35)];
    dropBackV.backgroundColor = color(0, 0, 0, 0.3);
    dropBackV.alpha = 0;
    [self.view addSubview:dropBackV];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [dropBackV addGestureRecognizer:tap];
    
    dropV = [[UITableView alloc] initWithFrame:CGRectMake(0, JLNavH+35, SCREEN_WIDTH, 0) style:UITableViewStylePlain];
    dropV.delegate = self;
    dropV.dataSource = self;
    [self.view addSubview:dropV];
    dropV.tableFooterView = [UIView new];
    
}

#pragma mark -- 布局配件信息
- (void)setUICollectionView {
    //布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGFloat height;
    if (self.userId) {
        height = JLNavH+40;
    }else {
        height = JLNavTab+40;
    }
    
    mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, JLNavH+40, SCREEN_WIDTH, SCREEN_HEIGHT-height) collectionViewLayout:layout];
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
    mainCollectionView.backgroundColor = [UIColor clearColor];
    mainCollectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainCollectionView];
    
    //注册
    [mainCollectionView registerClass:[shopsCell class] forCellWithReuseIdentifier:CellIdentifier];
    
    mainCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadLastData)];
}

#pragma mark -- TableView 的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (staBtn) {
        return 8;
    }else {
        return 20;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.products removeAllObjects];
    UIButton *sender1 = (UIButton *)[_titleV viewWithTag:1000];
    UIButton *sender2 = (UIButton *)[_titleV viewWithTag:1001];
    sender1.selected = NO;
    sender2.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        dropV.height = 0;
        dropBackV.alpha=0;
    }];
    NSLog(@"第%ld行",indexPath.row);
    if (staBtn==YES) {
        UIButton *sender = (UIButton *)[_titleV viewWithTag:1001];
        if (indexPath.row==0) {
            [sender setTitle:@"配件分类" forState:UIControlStateNormal];
            CGFloat w = [XYString WidthForString:@"配件分类" withSizeOfFont:14]+2;
            [sender setTitleEdgeInsets:UIEdgeInsetsMake(0, -14, 0, 14)];
            [sender setImageEdgeInsets:UIEdgeInsetsMake(0, w, 0, -w)];
        }else {
            [sender setTitle:classArr[indexPath.row] forState:UIControlStateNormal];
            CGFloat w = [XYString WidthForString:classArr[indexPath.row] withSizeOfFont:14]+2;
            [sender setTitleEdgeInsets:UIEdgeInsetsMake(0, -14, 0, 14)];
            [sender setImageEdgeInsets:UIEdgeInsetsMake(0, w, 0, -w)];
        }
        classStr = sender.titleLabel.text;
    }else {
        UIButton *sender = (UIButton *)[_titleV viewWithTag:1000];
        if (indexPath.row==0) {
            [sender setTitle:@"挖机品牌" forState:UIControlStateNormal];
            CGFloat w = [XYString WidthForString:@"质量选择" withSizeOfFont:14]+2;
            [sender setTitleEdgeInsets:UIEdgeInsetsMake(0, -14, 0, 14)];
            [sender setImageEdgeInsets:UIEdgeInsetsMake(0, w, 0, -w)];
        }else {
            [sender setTitle:modelsArr[indexPath.row] forState:UIControlStateNormal];
            CGFloat w = [XYString WidthForString:modelsArr[indexPath.row] withSizeOfFont:14]+2;
            [sender setTitleEdgeInsets:UIEdgeInsetsMake(0, -14, 0, 14)];
            [sender setImageEdgeInsets:UIEdgeInsetsMake(0, w, 0, -w)];
        }
        modelStr = sender.titleLabel.text;
    }
    [self request];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    if (staBtn) {
        cell.textLabel.text = classArr[indexPath.row];
    }else {
        cell.textLabel.text = modelsArr[indexPath.row];
    }
    cell.textLabel.font = [UIFont fontWithName:[UIFont familyNames][1] size:15];
    
    return cell;
}

#pragma mark -- CollectionView 的代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    shopsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    AVObject *product = self.products[indexPath.row];
    NSString *imgurl = [avoidNull(product[@"image"]) componentsSeparatedByString:@","][0];
    
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:avoidNull([imgurl imgUrlUpdate])] placeholderImage:[UIImage imageNamed:@"img_ default"]];
    cell.titleLB.text = [product objectForKey:@"title"];
    cell.nameLB.text = [NSString stringWithFormat:@"价格：%@元",avoidNull([product objectForKey:@"price"])];
    
    if (self.userId==nil) {
        [self setshadow:cell];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((SCREEN_WIDTH-30)/2, (SCREEN_WIDTH-30)/2+50);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了第%ld个",(long)indexPath.row);
    PartsDetailsVC *MVC = [[PartsDetailsVC alloc] init];
    MVC.object = self.products[indexPath.row];
    MVC.Personal = self.Personal;
    [self.navigationController pushViewController:MVC animated:YES];
}
#pragma mark -- 按钮的点击事件
- (void)stauseAction:(UIButton *)sender {
    
    UIButton *sender1 = (UIButton *)[_titleV viewWithTag:1000];
    UIButton *sender2 = (UIButton *)[_titleV viewWithTag:1001];
    if (sender.selected) {
        sender.selected = NO;
        [UIView animateWithDuration:0.3 animations:^{
            dropV.height = 0;
            dropBackV.alpha=0;
        }];
    }else {
        sender.selected = YES;
        [UIView animateWithDuration:0.3 animations:^{
            dropV.height = 308;
            dropBackV.alpha=1;
        }];
        if (sender.tag==1000) {
            sender2.selected = NO;
            staBtn = NO;
        }else {
            sender1.selected = NO;
            staBtn = YES;
        }
        [dropV reloadData];
    }
}
#pragma mark -- 背景的点击手势
- (void)tapAction {
    
    UIButton *sender1 = (UIButton *)[_titleV viewWithTag:1000];
    UIButton *sender2 = (UIButton *)[_titleV viewWithTag:1001];
    sender1.selected = NO;
    sender2.selected = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        dropV.height = 0;
        dropBackV.alpha = 0;
    }];
}
#pragma  mark -- 上拉加载
- (void)loadLastData {
    [self request];
}

- (void)request {
    
    AVQuery *query = [AVQuery queryWithClassName:@"Supply"];
    [query orderByDescending:@"createdAt"];//updatedAt createdAt
    
    if (self.userId) {
        [query whereKey:@"userId" hasPrefix:self.userId];
    }
    if (![modelStr isEqualToString:@"挖机品牌"]) {
        [query whereKey:@"brand" hasPrefix:modelStr];
    }
    if (![classStr isEqualToString:@"配件分类"]) {
        [query whereKey:@"class" hasPrefix:classStr];
    }
    [query setLimit:8];
    [query setSkip:self.products.count];
   
    [query includeKey:@"owner"];
    
    [SVProgressHUD showWithStatus:nil];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [mainCollectionView.mj_footer endRefreshing];
        if (!error) {
            NSLog(@"保存的信息=%@ 个数＝%ld",objects,objects.count);
            if (objects.count) {
                self.imgNil.hidden = YES;
                [SVProgressHUD dismiss];
                for (AVQuery *query in objects) {
                    [self.products addObject:query];
                }
                [mainCollectionView reloadData];
            }else {
                if (self.products.count) {
                    self.imgNil.hidden = YES;
                    [SVProgressHUD showMessage:@"无更多配件信息"];
                }else {
                    self.imgNil.hidden = NO;
                    [SVProgressHUD showMessage:@"暂时无数据"];
                    [mainCollectionView reloadData];
                }
            }
        }else {
            [SVProgressHUD showMessage:@"服务器繁忙，稍后重试"];
        }
    }];
}

#pragma mark -- 点击新手指引
- (void)GuidelinesDismm:(UITapGestureRecognizer *)tap {
    
    UIView *view = tap.view;
    view.hidden = YES;
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

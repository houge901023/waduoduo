//
//  PartsDetailsVC.m
//  waduoduo
//
//  Created by 名侯 on 2017/5/9.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import "PartsDetailsVC.h"
#import "shopsCell.h"
#import "SDCycleScrollView.h"
#import "chatVC.h"
#import "PartsVC.h"
#import "SDPhotoBrowser.h"
#import "LQPopUpView.h"
#import "HZIAPManager.h"
#import "payInfoVC.h"
#import "secondModel.h"

static NSString * CellIdentifier = @"CellIdentifier";

@interface PartsDetailsVC () <UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate,SDPhotoBrowserDelegate,RCIMUserInfoDataSource>
{
    UIView *headV;
    NSArray *imgurl;
    UILabel *pageLB;
    UILabel *promptLB;
    //布局产品
    UICollectionView *mainCollectionView;
    //
    NSMutableArray *collecArr;
}

@property (strong, nonatomic) NSMutableArray *products;
@property (nonatomic ,strong) UIButton *backHomeBtn;
@property (nonatomic ,strong) UIView *backView;
@property (nonatomic ,strong) NSMutableArray *payArr;
@property (nonatomic ,strong) secondModel *model;

@end

@implementation PartsDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"产品详情";
    
    [self setup];
    [self setUICollectionView];
    [self request];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.backHomeBtn.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.backHomeBtn.hidden = YES;
}

- (NSMutableArray *)products {
    if (_products == nil) {
        _products = [NSMutableArray array];
    }
    return _products;
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backView.backgroundColor = UIColorWithRGBA(0, 0, 0, 0.3);
        _backView.hidden = YES;
        [APP_DELE.window addSubview:_backView];
    }
    return _backView;
}

- (UIButton *)backHomeBtn {
    if (_backHomeBtn==nil) {
        
        _backHomeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, SCREEN_HEIGHT-70-JLTabH, 50, 50)];
        _backHomeBtn.backgroundColor = color(0, 0, 0, 0.6);
        _backHomeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_backHomeBtn setTitle:@"首页" forState:UIControlStateNormal];
        [_backHomeBtn setImage:[UIImage imageNamed:@"backhome"] forState:UIControlStateNormal];
        [_backHomeBtn addTarget:self action:@selector(backhomeAction) forControlEvents:UIControlEventTouchUpInside];
        [self setYuan:_backHomeBtn size:5];
        
        CGFloat w = [XYString WidthForString:@"首页" withSizeOfFont:13];
        [_backHomeBtn setTitleEdgeInsets:UIEdgeInsetsMake(22, -22, 0, 0)];
        [_backHomeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 20, -w)];
        
        [APP_DELE.window addSubview:_backHomeBtn];
    }
    return _backHomeBtn;
}

- (void)setup {
    
    self.payArr = [[NSMutableArray alloc] initWithArray:[AVUser currentUser][@"payList"]];
    self.model = [[secondModel alloc] init];
    self.model.Linkman = avoidNull(self.object[@"title"]);
    self.model.Mobile = avoidNull(self.object[@"phone"]);
    
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    
    //取值
    imgurl = [avoidNull(self.object[@"image"]) componentsSeparatedByString:@","];
    NSString *content = self.object[@"content"];
    if ([self.object[@"permissions"] isEqualToString:@"2"]) {
        content = [NSString stringWithFormat:@"%@\n联系电话：%@",content,self.object[@"phone"]];
    }
    CGFloat H = [XYString HeightForText:content withSizeOfLabelFont:14 withWidthOfContent:SCREEN_WIDTH-30];
    
    headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kWidth5(180)+325+H)];
    headV.backgroundColor = [UIColor clearColor];
    
    //轮播图
    SDCycleScrollView *sdcy = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kWidth5(180)) imageURLStringsGroup:imgurl];
    sdcy.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    sdcy.placeholderImage = [UIImage imageNamed:@"wdd_placeholder"];
    sdcy.showPageControl = NO;
    sdcy.delegate = self;
    sdcy.autoScroll = NO;
    sdcy.infiniteLoop = NO;
    [headV addSubview:sdcy];
    
    pageLB = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-65, kWidth5(180)-30, 50, 20)];
    pageLB.backgroundColor = color(0, 0, 0, 0.6);
    pageLB.textColor = [UIColor whiteColor];
    pageLB.textAlignment = NSTextAlignmentCenter;
    pageLB.font = [UIFont systemFontOfSize:16];
    pageLB.text = [NSString stringWithFormat:@"1/%ld",imgurl.count];
    [headV addSubview:pageLB];
    [self setYuan:pageLB size:10];
    
    //名称
    UIView *backV2 = [[UIView alloc] initWithFrame:CGRectMake(0, kWidth5(180), SCREEN_WIDTH, 60)];
    backV2.backgroundColor = [UIColor whiteColor];
    [headV addSubview:backV2];
    
    UIButton *sender = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-45, 15, 30, 30)];
    [sender setImage:[UIImage imageNamed:@"supply_collec"] forState:UIControlStateNormal];
    [sender setImage:[UIImage imageNamed:@"supply_collec_sele"] forState:UIControlStateSelected];
    [sender addTarget:self action:@selector(collecAction:) forControlEvents:UIControlEventTouchUpInside];
    [backV2 addSubview:sender];
    //自己的没有收藏按钮
    AVUser *user = self.object[@"owner"];
    if ([[AVUser currentUser].objectId isEqualToString:user.objectId]) {
        sender.hidden = YES;
        if (self.Personal==YES) {
            [self configureRightImage:@"garbage"];
        }
    }else {
        if (self.model.Mobile.length > 0 && ![self.object[@"permissions"] isEqualToString:@"2"]) {
            [self configureRightImage1:@"xq_sj" setImage2:@"chat_2"];
        }else {
            [self configureRightImage:@"chat_2"];
        }
    }
    collecArr = [[NSMutableArray alloc] initWithArray:[AVUser currentUser][@"collection"]];
    if ([collecArr containsObject:self.object[@"objectId"]]) {
        sender.selected = YES;
    }
    
    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 20)];
    titleLB.textColor = titleC1;
    titleLB.text = self.object[@"title"];
    titleLB.font = [UIFont systemFontOfSize:15];
    [backV2 addSubview:titleLB];
    
    UILabel *priceLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, SCREEN_WIDTH-30, 20)];
    priceLB.textColor = titleC1;
    priceLB.font = [UIFont systemFontOfSize:14];
    [backV2 addSubview:priceLB];
    
    NSString *str = [NSString stringWithFormat:@"¥ %@",self.object[@"price"]];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
    [attri addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:titleC2} range:NSMakeRange(1, str.length-1)];
    priceLB.attributedText = attri;
    
    UIView *backV3 = [[UIView alloc] initWithFrame:CGRectMake(0, kVIEW_BY(backV2)+10, SCREEN_WIDTH, 140)];
    backV3.backgroundColor = [UIColor whiteColor];
    [headV addSubview:backV3];
    
    [self PixeH:CGPointMake(0, 59) lenght:SCREEN_WIDTH add:backV2];
    [self PixeH:CGPointMake(0, 0) lenght:SCREEN_WIDTH add:backV3];
    [self PixeH:CGPointMake(0, 139) lenght:SCREEN_WIDTH add:backV3];
    
    for (int i=0; i<4; i++) {
        
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+i*30, SCREEN_WIDTH-30, 30)];
        titleLB.font = [UIFont systemFontOfSize:15];
        titleLB.textColor = titleC1;
        [backV3 addSubview:titleLB];
        
        NSString *title3 = @[@"质量：",@"型号：",@"分类：",@"件号："][i];
        NSString *brand = [NSString stringWithFormat:@"%@%@",self.object[@"brand"],self.object[@"model"]];
        NSString *value = @[avoidNull(self.object[@"quality"]),
                            brand,
                            avoidNull(self.object[@"class"]),
                            avoidNull(self.object[@"partsNum"])][i];
        
        NSString *str = [NSString stringWithFormat:@"%@%@",title3,value];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
        [attri addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:titleC2} range:NSMakeRange(3, str.length-3)];
        titleLB.attributedText = attri;
    }
    
    UIView *backV4 = [[UIView alloc] initWithFrame:CGRectMake(0, kVIEW_BY(backV3)+10, SCREEN_WIDTH, H+50)];
    backV4.backgroundColor = [UIColor whiteColor];
    [headV addSubview:backV4];
    
    UILabel *title4LB = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 30)];
    title4LB.font = [UIFont systemFontOfSize:15];
    title4LB.text = @"产品详情";
    title4LB.textColor = titleC1;
    [backV4 addSubview:title4LB];
    
    UILabel *valueLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, SCREEN_WIDTH-30, 1000)];
    valueLB.textColor = titleC2;
    valueLB.text = content;
    valueLB.font = [UIFont systemFontOfSize:14];
    valueLB.numberOfLines = 0;
    [valueLB sizeToFit];
    [backV4 addSubview:valueLB];
    
    [self PixeH:CGPointMake(0, 0) lenght:SCREEN_WIDTH add:backV4];
    [self PixeH:CGPointMake(0, H+49) lenght:SCREEN_WIDTH add:backV4];
    
    //组头
    UIView *backV5 = [[UIView alloc] initWithFrame:CGRectMake(0, kVIEW_BY(backV4)+15, SCREEN_WIDTH, 40)];
    backV5.backgroundColor = [UIColor whiteColor];
    [headV addSubview:backV5];
    
    [self PixeH:CGPointMake(0, 0) lenght:SCREEN_WIDTH add:backV5];
    [self PixeH:CGPointMake(0, 39) lenght:SCREEN_WIDTH add:backV5];
    
    UILabel *title5LB = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 100, 20)];
    title5LB.font = [UIFont systemFontOfSize:15];
    title5LB.text = @"其它配件";
    title5LB.textColor = mainBlue;
    [backV5 addSubview:title5LB];
    
    UIView *linV = [[UIView alloc] initWithFrame:CGRectMake(15, 13, 2, 14)];
    linV.backgroundColor = mainBlue;
    [backV5 addSubview:linV];
    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 5, 70, 30)];
    [moreBtn setTitle:@"更多>>" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [moreBtn setTitleColor:mainBlue forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    [backV5 addSubview:moreBtn];
    
}

#pragma mark -- 布局配件信息
- (void)setUICollectionView {
    
    //布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, JLNavH, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH) collectionViewLayout:layout];
    mainCollectionView.backgroundColor = [UIColor clearColor];
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
    mainCollectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainCollectionView];
    
    //注册
    [mainCollectionView registerClass:[shopsCell class] forCellWithReuseIdentifier:CellIdentifier];
    [mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"a"];
    //注册尾部
    [mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"a"];
    layout.footerReferenceSize = CGSizeMake(50, 50);
    
    promptLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 20)];
    promptLB.textColor = titleC3;
    promptLB.font = [UIFont systemFontOfSize:13];
    promptLB.text = @"暂时没有其他配件";
    promptLB.textAlignment = NSTextAlignmentCenter;
    promptLB.hidden = YES;
}

#pragma mark -- CollectionView 的代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    shopsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    AVObject *product = self.products[indexPath.row];
    NSString *url = [product[@"image"] componentsSeparatedByString:@","][0];
    
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:avoidNull([url imgUrlUpdate])] placeholderImage:[UIImage imageNamed:@"wdd_placeholder"]];
    cell.titleLB.text = [product objectForKey:@"title"];
    cell.nameLB.text = [NSString stringWithFormat:@"价格：%@元",avoidNull([product objectForKey:@"price"])];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat W = (SCREEN_WIDTH-45)/2;
    return CGSizeMake(W, W+50);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(15, 15, 15, 15);
}
//调整列距
//-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 15;
//}
//调整行距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={SCREEN_WIDTH ,headV.height};
    return size;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    PartsDetailsVC *MVC = [[PartsDetailsVC alloc] init];
    MVC.object = self.products[indexPath.row];
    [self.navigationController pushViewController:MVC animated:YES];
}
#pragma mark -- 设置头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    reusableview.backgroundColor = [UIColor clearColor];
    
    if (kind == UICollectionElementKindSectionHeader){
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"a" forIndexPath:indexPath];
        
        [headerView addSubview:headV];
        reusableview = headerView;
        return reusableview;
    }else {
        UICollectionReusableView *footerView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"a" forIndexPath:indexPath];
        
        footerView.backgroundColor = [UIColor clearColor];
        [footerView addSubview:promptLB];
        
        return footerView;
    }
}

#pragma mark -- 其他配件
- (void)request {
    
    AVQuery *query = [AVQuery queryWithClassName:@"Supply"];
    [query orderByDescending:@"createdAt"];//updatedAt createdAt
    
    NSLog(@"用户信息=%@",self.object[@"owner"]);
    
    [query whereKey:@"userId" hasPrefix:self.object[@"userId"]];
    [query whereKey:@"objectId" notEqualTo:self.object[@"objectId"]];
    
    [query setLimit:4];
    
    [query includeKey:@"owner"];
    
    [self showLoding:FrameNav setText:@"正在加载中..."];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      
        if (!error) {
            NSLog(@"保存的信息=%@ 个数＝%ld",objects,objects.count);
            [self hidenLoding];
            if (objects.count) {
                for (AVQuery *query in objects) {
                    [self.products addObject:query];
                }
                [mainCollectionView reloadData];
            }
        }else {
            
            [EasyEmptyView showErrorInView:self.maskView callback:^(EasyEmptyView *view, UIButton *button, callbackType callbackType) {
                [EasyEmptyView hiddenEmptyInView:self.maskView];
                [self request];
            }];
        }
    }];
    
}

#pragma mark -- 收藏的点击事件
- (void)collecAction:(UIButton *)sender {
    
    if (sender.selected) {
        [collecArr removeObject:self.object[@"objectId"]];
        [self collecRequest:@"取消收藏成功" set:sender set:NO];
        APP_DELE.refreshNum = 1;
    }else {
        if (collecArr.count>=10) {
            [EasyTextView showInfoText:@"最多支持收藏10件商品，请整理个人收藏"];
            return;
        }
        sender.selected = YES;
        [collecArr addObject:self.object[@"objectId"]];
        [self collecRequest:@"收藏成功" set:sender set:YES];
    }
}

#pragma mark -- 收藏的网络请求
- (void)collecRequest:(NSString *)msg set:(UIButton *)sender set:(BOOL)sele {
    
    AVUser *user = [AVUser currentUser];
    [user setObject:collecArr forKey:@"collection"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [EasyTextView showSuccessText:msg];
            sender.selected = sele;
        }else {
            [EasyTextView showErrorText:[NSString stringWithFormat:@"错误码：%ld",error.code]];
        }
    }];
}

- (void)rightNavAction {
    
    if ([AVUser currentUser]==nil) {
        [EasyTextView showInfoText:@"请先登录"];
        return;
    }
    
    AVUser *user = self.object[@"owner"];
    
    if ([[AVUser currentUser].objectId isEqualToString:user.objectId]) {
        
        LQPopUpView *popUpView = [[LQPopUpView alloc] initWithTitle:@"提示" message:@"是否确定删除配件"];
        
        [popUpView addBtnWithTitle:@"取消" type:LQPopUpBtnStyleCancel handler:^{
            // do something...
        }];
        
        [popUpView addBtnWithTitle:@"确定" type:LQPopUpBtnStyleDefault handler:^{
            [self.object deleteInBackground];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
//            NSArray *arr = [self.object[@"image"] componentsSeparatedByString:@","];
//            AVQuery *query = [AVQuery queryWithClassName:@"_File"];
//            [query whereKey:@"url" containedIn:arr];
//            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//                if (objects.count>0) {
//                    for (AVFile *file in objects) {
//                        [file deleteInBackground];
//                    }
//                }
//            }];
        }];
        
        [popUpView showInView:self.view preferredStyle:LQPopUpViewStyleAlert];

        
    }else {
        if (APP_DELE.newV==NO) {
            [EasyTextView showInfoText:@"请更新版本"];
            return;
        }
        if (APP_DELE.noPower==YES) {
            return [EasyTextView showInfoText:@"你暂时无权限访问"];
        }
        chatVC *conversationVC = [[chatVC alloc]init];
        conversationVC.conversationType = ConversationType_PRIVATE;
        conversationVC.targetId = user.objectId;
        conversationVC.title = user.username;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
}

- (void)btnAction:(UIButton *)btn {
    
    if ([AVUser currentUser]==nil) {
        [EasyTextView showInfoText:@"请先登录"];
        return;
    }
    
    AVUser *user = self.object[@"owner"];
    
    if (btn.tag == 7000) {
        
        self.backView.hidden = NO;
        [EasyLoadingView showLoadingImage:@"正在获取中..."];
        [[HZIAPManager shareIAPManager] startIAPWithProductID:@"200010" completeHandle:^(IAPResultType type, NSData * _Nonnull data) {
            if (type == IAPResultVerSuccess || type == IAPResultSuccess) {
                
                if (self.payArr.count == 0) {
                    [self.payArr addObject:[[self.model mj_keyValues] jsonStr]];
                }else {
                    [self.payArr insertObject:[[self.model mj_keyValues] jsonStr] atIndex:0];
                }
                [self updatePay];
            }else {
                self.backView.hidden = YES;
            }
        }];
        
    }else {
        if (APP_DELE.newV==NO) {
            [EasyTextView showInfoText:@"请更新版本"];
            return;
        }
        if (APP_DELE.noPower==YES) {
            return [EasyTextView showInfoText:@"你暂时无权限访问"];
        }
        chatVC *conversationVC = [[chatVC alloc]init];
        conversationVC.conversationType = ConversationType_PRIVATE;
        conversationVC.targetId = user.objectId;
        conversationVC.title = user.username;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
}

- (void)updatePay {
    
    AVUser *user = [AVUser currentUser];
    [user setObject:self.payArr forKey:@"payList"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        self.backView.hidden = YES;
        [EasyLoadingView hidenLoading];
        if (succeeded) {
            payInfoVC *MVC = [[payInfoVC alloc] init];
            MVC.isSuccess = 1;
            MVC.tel = self.model.Mobile;
            [self.navigationController pushViewController:MVC animated:YES];
        }else {
            payInfoVC *MVC = [[payInfoVC alloc] init];
            MVC.isSuccess = 2;
            MVC.tel = self.model.Mobile;
            [self.navigationController pushViewController:MVC animated:YES];
        }
    }];
    
}

- (void)moreAction {
    
    PartsVC *MVC = [[PartsVC alloc] init];
    MVC.userId = avoidNull(self.object[@"owner"][@"objectId"]);
    MVC.title = [NSString stringWithFormat:@"%@的配件",avoidNull(self.object[@"owner"][@"username"])];
    [self.navigationController pushViewController:MVC animated:YES];
}

- (void)backhomeAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark -- 点击banner图
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = index;
//    browser.sourceImagesContainerView = cycleScrollView;
    browser.imageCount = imgurl.count;
    browser.delegate = self;
    [browser show];
}

#pragma mark -- 滚动banner
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    NSLog(@"下标=%ld",index);
    pageLB.text = [NSString stringWithFormat:@"%ld/%ld",index+1,imgurl.count];
}

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = imgurl[index];
    NSURL *url = [NSURL URLWithString:[imageName imgUrlUpdate]];
    
    return url;
}
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    
    UIImage *image = [UIImage new];
    return image;
}

#pragma mark -- 融云会话列表
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
    NSLog(@"用户id=%@",userId);
    
    AVUser *bbb = [AVQuery getUserObjectWithId:userId];
    
    RCUserInfo *use = [[RCUserInfo alloc] init];
    use.name = avoidNull(bbb.username);
    use.portraitUri = bbb[@"iconHead"];
    completion(use);
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

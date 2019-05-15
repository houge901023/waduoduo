//
//  MycollecVC.m
//  waduoduo
//
//  Created by 名侯 on 2017/5/12.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import "MycollecVC.h"
#import "shopsCell.h"
#import "PartsDetailsVC.h"

static NSString * CellIdentifier = @"CellIdentifier";

@interface MycollecVC () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    //布局商品
    UICollectionView *mainCollectionView;
}

@property (strong, nonatomic) NSMutableArray *products;

@end

@implementation MycollecVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    
    [self setUICollectionView];
    [self getCollection];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (APP_DELE.refreshNum==1) {
        APP_DELE.refreshNum = 0;
        [self getCollection];
    }
}

- (NSMutableArray *)products {
    if (_products == nil) {
        _products = [NSMutableArray array];
    }
    return _products;
}

#pragma mark -- 布局配件信息
- (void)setUICollectionView {
    //布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, JLNavH, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH) collectionViewLayout:layout];
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
    mainCollectionView.backgroundColor = [UIColor clearColor];
    mainCollectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainCollectionView];
    
    //注册
    [mainCollectionView registerClass:[shopsCell class] forCellWithReuseIdentifier:CellIdentifier];
    
}

#pragma mark -- CollectionView 的代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    shopsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    AVObject *product = self.products[indexPath.row];
    NSString *imgurl = [avoidNull(product[@"image"]) componentsSeparatedByString:@","][0];
    
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:avoidNull([imgurl imgUrlUpdate])] placeholderImage:[UIImage imageNamed:@"default_img"]];
    cell.titleLB.text = [product objectForKey:@"title"];
    cell.nameLB.text = [NSString stringWithFormat:@"价格：%@元",avoidNull([product objectForKey:@"price"])];
    
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
    [self.navigationController pushViewController:MVC animated:YES];
}

#pragma mark -- 获取收藏
- (void)getCollection {
    
    AVUser *user = [AVUser currentUser];
    NSMutableArray *arr = [user objectForKey:@"collection"];
    AVQuery *query = [AVQuery queryWithClassName:@"Supply"];

    if (arr) {
        [query whereKey:@"objectId" containedIn:arr];
    }else {
        return;
    }
    [self.products removeAllObjects];
    [query setSkip:self.products.count];
    // image 为 File
    [query includeKey:@"image"];
    
    [self showLoding:FrameNav setText:@"正在加载中..."];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"数组个数＝%ld",objects.count);
        
        if (!error) {
            if (objects.count) {
                [self hidenLoding];
                for (AVQuery *query in objects) {
                    [self.products addObject:query];
                }
            }else {
                [EasyEmptyView showEmptyInView:self.maskView callback:^(EasyEmptyView *view, UIButton *button, callbackType callbackType) {
                    
                }];
            }
            [mainCollectionView reloadData];
        }else {
            [EasyEmptyView showErrorInView:self.maskView callback:^(EasyEmptyView *view, UIButton *button, callbackType callbackType) {
                [EasyEmptyView hiddenEmptyInView:self.maskView];
                [self getCollection];
            }];
        }
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

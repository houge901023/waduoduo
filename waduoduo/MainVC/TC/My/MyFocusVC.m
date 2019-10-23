//
//  MyFocusVC.m
//  SouMi
//
//  Created by Apple  on 2019/4/2.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import "MyFocusVC.h"
#import "headCollCell.h"
#import "ExpertsDetailsVC.h"

static NSString * const HeadCollCellID = @"HeadCollCellID";

@interface MyFocusVC () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *mainCollecView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation MyFocusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的专家";
    
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.dataArr = [[NSMutableArray alloc] initWithArray:[AVUser currentUser][@"collection"]];
    [self.mainCollecView reloadData];
}

- (void)setUI {
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake((SCREEN_WIDTH-3)/4, 90);
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    layout.minimumLineSpacing = 0;
//    layout.minimumInteritemSpacing = 0;
    
    UICollectionView *collecView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, JLNavH, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH) collectionViewLayout:layout];
    collecView.backgroundColor = [UIColor whiteColor];
    collecView.delegate = self;
    collecView.dataSource = self;
    collecView.showsHorizontalScrollIndicator = NO;
    [collecView registerNib:[UINib nibWithNibName:@"headCollCell" bundle:nil] forCellWithReuseIdentifier:HeadCollCellID];
    [self.view addSubview:collecView];
    self.mainCollecView = collecView;
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    headCollCell *Cell = [collectionView dequeueReusableCellWithReuseIdentifier:HeadCollCellID forIndexPath:indexPath];
    NSString *code = self.dataArr[indexPath.row];
    NSArray  *array = [code componentsSeparatedByString:@"^"];
    if (array.count>2) {
        [Cell.headImg sd_setImageWithURL:[NSURL URLWithString:array[1]] placeholderImage:[UIImage imageNamed:@"people"]];
        Cell.nameLB.text = array[2];
    }
    return Cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *code = self.dataArr[indexPath.row];
    NSArray  *array = [code componentsSeparatedByString:@"^"];
    if (array.count>2) {
        ExpertsDetailsVC *MVC = [[ExpertsDetailsVC alloc] init];
        MVC.ExpertsNo = array[0];
        [self.navigationController pushViewController:MVC animated:YES];
    }
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

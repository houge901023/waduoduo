//
//  expertsHeadCell.m
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/11.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import "expertsHeadCell.h"
#import "headCollCell.h"
#import "planListModel.h"

static NSString * const HeadCollCellID = @"HeadCollCellID";

@interface expertsHeadCell () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *mainCollecView;

@end

@implementation expertsHeadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake((SCREEN_WIDTH-20)/4, 90);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    UICollectionView *collecView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 180) collectionViewLayout:layout];
    collecView.backgroundColor = [UIColor whiteColor];
    collecView.delegate = self;
    collecView.dataSource = self;
    collecView.showsHorizontalScrollIndicator = NO;
    [collecView registerNib:[UINib nibWithNibName:@"headCollCell" bundle:nil] forCellWithReuseIdentifier:HeadCollCellID];
    [self.contentView addSubview:collecView];
    self.mainCollecView = collecView;
}
- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self.mainCollecView reloadData];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataArr.count>8) {
        return 8;
    }else {
        return self.dataArr.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    headCollCell *Cell = [collectionView dequeueReusableCellWithReuseIdentifier:HeadCollCellID forIndexPath:indexPath];
    planListModel *model = self.dataArr[indexPath.row];
    [Cell.headImg sd_setImageWithURL:[NSURL URLWithString:model.authheadImlUrl] placeholderImage:[UIImage imageNamed:@"people"]];
    Cell.nameLB.text = model.authName;
    return Cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.headTap(indexPath.row);
}
@end

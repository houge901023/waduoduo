//
//  OthersInfoVC.m
//  waduoduo
//
//  Created by 名侯 on 2017/5/15.
//  Copyright © 2017年 侯彦名. All rights reserved.
//

#import "OthersInfoVC.h"
#import "setCell.h"

@interface OthersInfoVC () <UITableViewDelegate,UITableViewDataSource>
{
    CGFloat cellH;
}
@property (nonatomic ,strong) UITableView *mainTV;
@property (nonatomic ,strong) NSArray *titleArr;
@property (nonatomic ,strong) NSArray *valueArr;

@end

@implementation OthersInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    self.view.backgroundColor = BackGroundColor;
    
    [self setup];
}
- (NSArray *)titleArr {
    if (_titleArr==nil) {
        _titleArr = @[@"手机号",@"ID",@"公司",@"职业",@"挖机型号",@"所在地",@"个人简介"];
    }
    return _titleArr;
}
- (void)setup {
    
    _mainTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _mainTV.backgroundColor = [UIColor clearColor];
    _mainTV.delegate = self;
    _mainTV.dataSource = self;
    [self.view addSubview:_mainTV];
    
    //head
    UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
    headV.backgroundColor = [UIColor clearColor];
    _mainTV.tableHeaderView = headV;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 80)];
    view.backgroundColor = [UIColor whiteColor];
    [headV addSubview:view];
    [self PixeH:CGPointMake(0, 0) lenght:SCREEN_WIDTH add:view];
    [self PixeH:CGPointMake(0, 79) lenght:SCREEN_WIDTH add:view];
    
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
    [iconImg sd_setImageWithURL:[NSURL URLWithString:self.imgurl] placeholderImage:[UIImage imageNamed:@"my_icon"]];
    iconImg.layer.cornerRadius = 30;
    iconImg.layer.masksToBounds=YES;
    [view addSubview:iconImg];
    
    UILabel *nameLB = [[UILabel alloc] initWithFrame:CGRectMake( 90, 30, SCREEN_WIDTH-105, 20)];
    nameLB.textColor = titleC2;
    nameLB.font = [UIFont systemFontOfSize:15];
    nameLB.text = self.name;
    nameLB.textAlignment = NSTextAlignmentRight;
    [view addSubview:nameLB];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==6) {
        if (cellH>44) {
            return cellH;
        }else {
            return 44;
        }
    }else {
        return 44;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    setCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[setCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = titleC1;
    cell.textLabel.text = self.titleArr[indexPath.row];
    
    cell.valueLB.text = self.dataArr[indexPath.row];
    
    if (indexPath.row==6) {
        CGFloat H = [XYString HeightForText:self.dataArr[indexPath.row] withSizeOfLabelFont:15 withWidthOfContent:SCREEN_WIDTH-115];
        NSLog(@"cell高度=%.2f",H);
        if (H>20) {
            cell.valueLB.textAlignment = NSTextAlignmentLeft;
            cell.valueLB.numberOfLines = 0;
            cell.valueLB.height = H;
            [cell sizeToFit];
        }else {
            cell.valueLB.textAlignment = NSTextAlignmentRight;
        }
        cellH = H+24;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//默认水平线
- (void)PixeH:(CGPoint)origin lenght:(CGFloat)length add:(UIView *)supview {
    
    CGFloat width = 1/[UIScreen mainScreen].scale;
    CGFloat offset;
    if (origin.y==0) {
        offset = 0;
    }else {
        offset = 1-width;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(origin.x, ceil(origin.y)+offset, length, width)];
    view.backgroundColor = BorderColor;
    [supview addSubview:view];
}

@end

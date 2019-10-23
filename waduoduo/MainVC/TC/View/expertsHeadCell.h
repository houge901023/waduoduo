//
//  expertsHeadCell.h
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/11.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface expertsHeadCell : UITableViewCell

@property (nonatomic ,strong) NSArray *dataArr;
@property (nonatomic, copy)   void(^headTap)(NSInteger index);

@end

//
//  ADImageVC.m
//  waduoduo
//
//  Created by Apple  on 2019/8/4.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import "ADImageVC.h"

@interface ADImageVC ()

@property (nonatomic ,strong) UIScrollView *mainSV;
@property (nonatomic ,strong) UIImageView *mainImageView;

@end

@implementation ADImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"活动详情";
    
    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"default_img"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (error) {
            
        }else {
            // 获取图片实际尺寸
            CGSize bigSize = image.size;
            self.mainImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/bigSize.width*bigSize.height);
            self.mainSV.contentSize = CGSizeMake(SCREEN_WIDTH, self.mainImageView.height);
            
        }
    }];
}

- (UIScrollView *)mainSV {
    if (_mainSV == nil) {
        _mainSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, JLNavH, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH)];
        [self.view addSubview:_mainSV];
    }
    return _mainSV;
}

- (UIImageView *)mainImageView {
    if (_mainImageView == nil) {
        _mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-JLNavH)];
        [self.mainSV addSubview:_mainImageView];
    }
    return _mainImageView;
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

//
//  BaseChoseImageView.m
//  fanglian
//
//  Created by luobin on 2017/8/21.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "BaseChoseImageView.h"
#import "SDWebImageManager.h"
#import "SDWebImageDownloader.h"
#import "UIImage+GIF.h"
#import "NSData+ImageContentType.h"

@implementation BaseChoseImageView


- (instancetype)init {
    self = [super init];
    if (self) {
        _picNumber = 3;
        _imageArray = [[NSMutableArray alloc] init];
        _subviewArray = [[NSMutableArray alloc] init];
        _previewType = PreviewWithAll;
        
        self.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
        self.userInteractionEnabled = YES;
        
        _itemWidth = ([UIScreen mainScreen].bounds.size.width - 52) / 3.0;
        
//        _imageContent = [[UIScrollView alloc] init];
//        _imageContent.userInteractionEnabled = YES;
//        _imageContent.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 140);
//        _imageContent.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 120);
//        _imageContent.showsHorizontalScrollIndicator = YES;
//        _imageContent.showsVerticalScrollIndicator = YES;
        
//        [self addSubview:_imageContent];
        
//        _addTile = [[UILabel alloc] init];
//        _addTile.frame = CGRectMake(20, 12, 120, 24);
//        _addTile.text = @"";
//        _addTile.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
//        _addTile.textColor = [UIColor colorWithRed:106/255.0 green:106/255.0 blue:106/255.0 alpha:1/1.0];
//
//        [_imageContent addSubview:_addTile];
//
//
//        _addPicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _addPicBtn.bounds = CGRectMake(0, 0, _itemWidth, _itemWidth);
//        _addPicBtn.center = CGPointMake(16 + _itemWidth / 2.0, _itemWidth / 2.0);
//        [_addPicBtn setImage:[UIImage imageNamed:@"the_choice_jia"] forState:UIControlStateNormal];
//        [_addPicBtn addTarget:self
//                       action:@selector(addTheImagePicturePressed)
//             forControlEvents:UIControlEventTouchUpInside];
//
//        [_imageContent addSubview:_addPicBtn];
        
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)addTheImagePicturePressed {
    
    if (_subviewArray.count >= _picNumber) {
        return;
    }
    
    
    if (_delegate) {
        [_delegate choseTheImageForChoseView:self];
    }
}

//添加通过网络获取的图片
- (void)addTheImageFromTheIntenet:(NSString *)urlStr {
    
    NSLog(@"添加网络图片%@", urlStr);
    
    NSURL *downUrl = [NSURL URLWithString:urlStr];
    [SDWebImageManager.sharedManager downloadImageWithURL:downUrl options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image) {
            
            
        }
    }];
}

//选择图片后刷新页面
- (void)reloadAllitemSubviewswithImage:(UIImage *)image {
    
//    _imageContent.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
//    _imageContent.contentSize = CGSizeMake(self.bounds.size.width, 320);
    
    PickMainImageView *imageItem = [[PickMainImageView alloc] init];
    imageItem.bounds = CGRectMake(0, 0, _itemWidth, _itemWidth);
    imageItem.selfWidth = _itemWidth;
    imageItem.delegate = self;
    imageItem.selfNum = _subviewArray.count;
    imageItem.image = image;
    NSInteger Xrow = (_imageArray.count ) / 3;
    NSInteger Yrow = (_imageArray.count ) % 3;
    imageItem.center = CGPointMake(16 + _itemWidth / 2.0 + (_itemWidth + 10 ) * Yrow, _itemWidth / 2.0 +  (_itemWidth + 10 ) * Xrow + 10);
    imageItem.contentMode = UIViewContentModeScaleAspectFill;
    imageItem.clipsToBounds = YES;
    imageItem.userInteractionEnabled = YES;
    
    NSInteger widCont = (_subviewArray.count + 1) % 3;
    NSInteger heightCont = ( _subviewArray.count + 1) / 3;
    
    _addPicBtn.center = CGPointMake(16 + _itemWidth / 2.0 + (_itemWidth + 10 ) * widCont,
                                    _itemWidth / 2.0 + (_itemWidth + 10 ) * heightCont);
    
    if (_previewType == PreviewWithAll) {
        [imageItem addTheDeleteButton];
        
    } else if (_previewType == PreviewWithBigType) {
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(previewAllImageWithBigImageView:)];
        tapGesture.numberOfTapsRequired = 1;
        
        [imageItem addGestureRecognizer:tapGesture];
    }
    
    [self addSubview:imageItem];
    
    [_imageArray addObject:image];
    [_subviewArray addObject:imageItem];
    
    
//    if (_imageArray.count <= 2) {
//        _imageContent.contentSize = CGSizeMake(self.bounds.size.width, 120);
//
//    } else if (_imageArray.count > 2 && _imageArray.count <= 5) {
//        _imageContent.contentSize = CGSizeMake(self.bounds.size.width, 230);
//
//        if (_imageContent.contentSize.height > _imageContent.bounds.size.height) {
//            _imageContent.contentOffset = CGPointMake(0,
//                                                      _imageContent.contentSize.height - _imageContent.bounds.size.height - 10);
//        }
//
//    } else if (_imageArray.count > 5 && _imageArray.count <= 8) {
//        _imageContent.contentSize = CGSizeMake(self.bounds.size.width, 330);
//        if (_imageContent.contentSize.height > _imageContent.bounds.size.height) {
//            _imageContent.contentOffset = CGPointMake(0,
//                                                      _imageContent.contentSize.height - _imageContent.bounds.size.height - 10);
//        }
//
//    } else if (_imageArray.count > 8) {
//        _imageContent.contentSize = CGSizeMake(self.bounds.size.width, 430);
//        if (_imageContent.contentSize.height > _imageContent.bounds.size.height) {
//            _imageContent.contentOffset = CGPointMake(0,
//                                                      _imageContent.contentSize.height - _imageContent.bounds.size.height - 10);
//        }
//    }
    
    if (_imageArray.count == _picNumber) {
        _addPicBtn.hidden = YES;
    }
}

- (void)previewAllImageWithBigImageView:(UITapGestureRecognizer *)sender {
    
    PickMainImageView *thetapView = (PickMainImageView *)sender.view;
    
    if (_delegate) {
        [_delegate previewWithTheBigTypeAndThePicNumber:thetapView.selfNum];
    }
}

//通过输入删除序号来删除相应的图片
- (void)deleteThePictureWithTheCountNumber:(NSInteger)countNumber {
    
    PickMainImageView *deitem = _subviewArray[countNumber];
    
    [self deleteTheSelectImage:deitem];
}

- (void)deleteTheSelectImage:(PickMainImageView *)sender {
//    for (int i = 0; i < _subviewArray.count; i++) {
//        PickMainImageView *singleSub = _subviewArray[i];
//        if (singleSub == sender) {
//            [singleSub removeFromSuperview];
//            [_subviewArray removeObjectAtIndex:i];
//            [_imageArray removeObjectAtIndex:i];
//            break;
//        }
//    }
    
    [_imageArray removeObject:sender.image];
    [_subviewArray removeObject:sender];
    [sender removeFromSuperview];
    
//    NSInteger wItemCont = _subviewArray.count % 3;
//    NSInteger hItemCont = _subviewArray.count / 3;
    for (int i = 0; i < _subviewArray.count; i++) {
        PickMainImageView *changeSub = _subviewArray[i];
        NSInteger Xrow = i / 3;
        NSInteger Yrow = i % 3;
        changeSub.center = CGPointMake(16 + _itemWidth / 2.0 + (_itemWidth + 10 ) * Yrow, _itemWidth / 2.0 +  (_itemWidth + 10 ) * Xrow + 10);
    }
    
    NSInteger widCont = (_subviewArray.count) % 3;
    NSInteger heightCont = ( _subviewArray.count) / 3;
    
    _addPicBtn.center = CGPointMake(16 + _itemWidth / 2.0 + (_itemWidth + 10 ) * widCont,
                                    _itemWidth / 2.0 + (_itemWidth + 10 ) * heightCont);
    
//    if (_imageArray.count <= 2) {
//        _imageContent.contentSize = CGSizeMake(self.bounds.size.width, 120);
//        
//    } else if (_imageArray.count > 2 && _imageArray.count <= 5) {
//        _imageContent.contentSize = CGSizeMake(self.bounds.size.width, 230);
//        
//    } else if (_imageArray.count > 5 && _imageArray.count <= 8) {
//        _imageContent.contentSize = CGSizeMake(self.bounds.size.width, 330);
//        
//    } else if (_imageArray.count > 8) {
//        _imageContent.contentSize = CGSizeMake(self.bounds.size.width, 430);
//    }
    
    
    for (int i = 0; i < _subviewArray.count; i++) {
        PickMainImageView *itemView = _subviewArray[i];
        itemView.selfNum = i;
    }
    
    _addPicBtn.hidden = NO;
    
    [self.delegate deleImg];
}


@end

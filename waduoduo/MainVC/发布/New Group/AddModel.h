//
//  AddModel.h
//  waduoduo
//
//  Created by Apple  on 2019/7/22.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddModel : NSObject

@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *placeHolder;
@property (nonatomic ,copy) NSString *type;
@property (nonatomic ,copy) NSString *intro;
@property (nonatomic ,copy) NSString *permissions; // 电话显示权限 1隐藏 2显示

@end

NS_ASSUME_NONNULL_END

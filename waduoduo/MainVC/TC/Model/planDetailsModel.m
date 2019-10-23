//
//  planDetailsModel.m
//  ZQjieshuo
//
//  Created by 股先生 on 2018/9/12.
//  Copyright © 2018年 侯彦名. All rights reserved.
//

#import "planDetailsModel.h"

@implementation planTeamList

@end

@implementation NotStartList

@end

@implementation planDetailsModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"planforecastitems" : [planTeamList class],@"explanlists" : [NotStartList class]};
}


- (NSString *)plandescription {
    NSString *htmlString = [NSString stringWithFormat:@"<html><head><style>img{max-width:100%%;height:auto !important;width:auto !important;};</style></head><body style='margin:0; padding:0;'>%@</body></html>", _plandescription==nil?@"":_plandescription];
    return htmlString;
}

@end


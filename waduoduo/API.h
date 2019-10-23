//
//  API.h
//  waduoduo
//
//  Created by Apple  on 2019/7/22.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#ifndef API_h
#define API_h

#define YZJX_MAIN        @"http://yizujixie.com55.cn"

//longitude=104.061752&latitude=30.583740&pageNumber=1&machineryFid=&machinerySid=&sizeId=&haveGunHead=&brandId=&priceId=&provinceId=&cityId=&isRent=1&version=1&platform=2
#define YZJX_ESLIST      [NSString stringWithFormat:@"%@/api/mechanice/second", YZJX_MAIN]

//version=1&platform=2
#define YZJX_ESSY        [NSString stringWithFormat:@"%@/api/mechanice/filterList", YZJX_MAIN]

//id=be270345f72d4e27a1a1b504b2a3c80b&longitude=104.061752&latitude=30.583740&token=&version=1&platform=2
#define YZJX_ESDETAILES  [NSString stringWithFormat:@"%@/api/mechanice/secondDetails", YZJX_MAIN]

#endif /* API_h */

//
//  Common.m
//  SanRentou
//
//  Created by 李洪旭 on 16/1/16.
//  Copyright © 2016年 安迪时代网络科技有限公司. All rights reserved.
//

#import "Common.h"
#import "sys/utsname.h"

static NSString *kLocalCookieName =@"MyProjectCookie";

static NSString *kLocalUserData =@"MyProjectLocalUser";

static NSString *kServerSessionCookie =@"jsessionid";

#define RightMargin 15
#define LeftMargin 15
#define Margin 8
#define SCREEN_WIDTH   ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT  ([UIScreen mainScreen].bounds.size.height)
@implementation Common

+ (void)addAlertOneButton:(NSString *)string{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:string delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
}
+ (void)verificationCode:(void(^)())blockYes blockNo:(void(^)(id time))blockNo {
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                blockYes();
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            int minutes = timeout / 60;
            NSString *strTime = [NSString stringWithFormat:@"%d分%.2d",minutes,seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
//                NSLog(@"____%@",strTime);
                blockNo(strTime);
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

//+ (NSString *)takeOutTheCode:(NSString *)name{
//    LJKLocationCityCode *code = [[LJKLocationCityCode alloc] init];
//    NSString *cityCode = [code returnCurrentCityCode:name];
//    return cityCode;
//}
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    NSString * CU = @"^1(3[0-2]|5[256]|8[156])\\d{8}$";
//    NSString * CT = @"^1((33|53|8|7[09])[0-9]|349)\\d{7}$";
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (NSString *)timeIntervalSince1970:(NSString *)dateline
{
    NSInteger date = [dateline floatValue]/1000 -(CGFloat)[[NSDate date] timeIntervalSince1970] ;
    if (date > 31536000) {
        return [NSString stringWithFormat:@"%ld年",(long)date / 31536000];
    }else if (date > 86400){
        return [NSString stringWithFormat:@"%ld天",(long)date / 86400];
    }else if (date > 3600){
        return [NSString stringWithFormat:@"%ld小时",(long)date / 3600];
    }else if (date > 60){
        return [NSString stringWithFormat:@"%ld分",(long)date / 60];
    }else if (date > 0){
        return [NSString stringWithFormat:@"%ld秒",(long)date];
    }else{
        return [NSString stringWithFormat:@"已经结束"];
    }
}

+ (NSString *)timeCountdown:(NSTimeInterval)timer {
    NSInteger date = timer - [[NSDate date] timeIntervalSince1970];//时间差
    NSString *string = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)date/3600,((long)date%3600)/60,((long)date%60)];
    return string;
}
+ (int)changeTimeToTimeSp:(NSString *)timeStr
{
    //获取当前时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //设置时间格式
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //将传过来的时间字符串转成date型
    NSDate *fromdater = [format dateFromString:timeStr];
    NSTimeInterval time1 = [zone secondsFromGMTForDate:fromdater];
    NSDate *fromdate = [fromdater dateByAddingTimeInterval:time1];
    //获取当前系统时间
    NSDate *date = [NSDate date];
    //通过当前时区转换为当前时间
    NSTimeInterval time2 = [zone secondsFromGMTForDate:date];
    //当前时间转成date型
    NSDate *dateNow = [date dateByAddingTimeInterval:time2];
    //当前时间与设定时间之间相差秒数
    int difference = ([fromdate timeIntervalSinceDate:dateNow]);
    return difference;
}
+ (NSString *)timeString:(NSString *)string{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[string integerValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}
+ (NSTimeInterval)dateConverter:(NSString *)string format:(NSString *)formatString{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    NSDate *date = [formatter dateFromString:string];
    NSLog(@"%@",date);
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    return timeInterval;
}
+ (NSString *)dateWithTimeIntervalSince1970:(NSString *)dateline
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSInteger date = [[NSDate date] timeIntervalSince1970] - [dateline integerValue];
    [formatter setDateFormat:@"MM月dd日"];
    if (date < 86400) {
        [formatter setDateFormat:@"mm"];
    }
    NSString *dateLoca = [NSString stringWithFormat:@"%@",dateline];
    NSTimeInterval time= [dateLoca doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    return [formatter stringFromDate:detaildate];
}
+ (NSMutableArray *)ModelTransformationWithResponseObject:(id)responseObject modelClass:(Class)modelClass
{
    
    NSMutableArray *array = [NSMutableArray array];
    
//    NSArray *appcications = responseObject[@"applications"];
//    for (NSDictionary *dict in appcications)
    {
//        [array addObject:[modelClass mj_objectWithKeyValues:dict]];
    }
    
    return array;
}
//保存cookie
+ (void)saveLoginSession {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *allCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookies];
    NSMutableDictionary *cookieDictionary;
    for (NSHTTPCookie *cookie in allCookies) {
        if ([cookie.name isEqualToString:kServerSessionCookie]) {
            cookieDictionary = [NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryForKey:kLocalCookieName]];
            [cookieDictionary setValue:cookie.properties forKey:@"cookieDict"];
            [defaults setValue:cookieDictionary forKey:kLocalCookieName];
             [self updateSession];
            [defaults synchronize];
            break;
        }else if([cookie.name isEqualToString:@"jsessionId"]){
           
        }
    }
}
//更新cookie
+ (void)updateSession{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *cookieDictionary = [defaults dictionaryForKey:kLocalCookieName];
    NSLog(@"%@",cookieDictionary);
    NSDictionary *cookieProperties = [cookieDictionary valueForKey:@"cookieDict"];
    if (cookieProperties != nil) {
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
}
//删除cookie
+ (void)removeLoginSession{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kLocalCookieName];
    [defaults synchronize];
}
//+ (NSURL *)imageURL:(NSString *)string {
//    NSString *string1 = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Base_URL,string1]];
//    return url;
//}
//+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage{
//    
//        if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
//        CGFloat btWidth = 0.0f;
//        CGFloat btHeight = 0.0f;
//        if (sourceImage.size.width > sourceImage.size.height) {
//            btHeight = ORIGINAL_MAX_WIDTH;
//            btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
//        } else {
//            btWidth = ORIGINAL_MAX_WIDTH;
//            btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
//        }
//        CGSize targetSize = CGSizeMake(btWidth, btHeight);
//        return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
//
//}
+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    UIGraphicsEndImageContext();
    return newImage;
}
+ (NSString *)percentageRounded:(CGFloat)decimal{
    NSString *string = nil ;
    if (decimal > 0 ) {
       CGFloat index =  ceilf(decimal);
        string = [NSString stringWithFormat:@"%d",(int)index];
    }else{
        string = @"0";
    }
    return string;
}
+ (NSString*)deviceString {
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSLog(@"%@",deviceString);
    if ([deviceString isEqualToString:@"iPhone1,1"])
    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])
    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])
    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])
    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])
    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])
    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone3,2"])
    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])
    return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])
    return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])
    return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])
    return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])
    return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])
    return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])
    return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])
    return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])
    return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])
    return @"Simulator"; NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}

+ (CGFloat)stringHeight:(NSString *)string font:(NSInteger)font{
    CGSize size;
    CGFloat height = 0;
    size = [string boundingRectWithSize:CGSizeMake(kScreen_Width-3*10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    //if (size.width/(SCREEN_WIDTH-60-LeftMargin-RightMargin-Margin) > 1) {
        height += size.height+30;
    //}else{
      //  height += size.height;
    //}
    return height;
}
+ (CGSize)stringwidth:(NSString *)string font:(NSInteger)font{
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:string];
    NSRange range = NSMakeRange(0, attrStr.length);
    // 获取该段attributedString的属性字典
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    // 计算文本的大小
    CGSize sizeToFit = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 16.0, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                                 attributes:dic        // 文字的属性
                                                    context:nil].size;
    return sizeToFit;
}
+ (NSMutableAttributedString *)Renderlabel:(NSString *)string start:(NSRange)colorRange start:(NSRange)fontRange font:(CGFloat)font color:(UIColor *)color {
    NSString *contentStr = string;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
    //颜色
    [str addAttribute:NSForegroundColorAttributeName value:color range:colorRange];
    //字体大小
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:fontRange];
    return str;
}
+ (NSMutableArray *)arrayWithMemberIsOnly:(NSMutableArray *)array
{
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [array count]; i++) {
        @autoreleasepool {
            if ([categoryArray containsObject:[array objectAtIndex:i]] == NO) {
                [categoryArray addObject:[array objectAtIndex:i]];
            }
        }
    }
    return categoryArray;
}
+ (UILabel *)initLabel:(NSString *)string addSubView:(UIView *)view{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:15];
    label.text = string;
    [view addSubview:label];
    return label;
}
+ (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, kScreen_Width, 64.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    UIImage *original = theImage;
//    CGRect frame = CGRectMake(0, 0, original.size.width, original.size.height);
//    // 开始一个Image的上下文
//    UIGraphicsBeginImageContextWithOptions(original.size, NO, 1.0);
//    // 添加圆角
//    [[UIBezierPath bezierPathWithRoundedRect:frame
//                                cornerRadius:25.0f] addClip];
//    // 绘制图片
//    [original drawInRect:frame];
//    // 接受绘制成功的图片
//    UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    return theImage;
}
@end

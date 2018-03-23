//
//  LucPhotoHelper.m
//  News
//
//  Created by wallstreetcn on 14-11-5.
//  Copyright (c) 2014年 wallstreetcn. All rights reserved.
//

#import "LucPhotoHelper.h"
#import "YZHelper.h"

static float ORIGINAL_MAX_WIDTH = 640.0f;

@implementation LucPhotoHelper

- (void)dealloc
{
    _delegate = nil;
}

- (void)editPortraitInView:(id)view
{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
//    [choiceSheet setDelegate:view];
//    [choiceSheet showFromTabBar:view];
//    UIViewController *c = (UIViewController *)view;
    [choiceSheet showFromTabBar:view];
}


#pragma mark - 相机 相片相关method
- (BOOL) isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
//判断后置摄像头
- (BOOL) isRearCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}
//判断前置摄像头
- (BOOL) isFrontCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos
{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary
{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary
{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType
{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark - 相片裁剪

- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage
{
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize
{
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
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//    portraitImg = [self imageByScalingToMaxSize:portraitImg];
//    // 裁剪
//    LucImageCropperViewController *imgEditorVC = [[LucImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) limitScaleRatio:3.0];
//    imgEditorVC.delegate = self;
   [picker dismissViewControllerAnimated:YES completion:^{
//       if (_target) {
//           
//           dispatch_async(dispatch_get_main_queue(), ^{
//               
//               [_target presentViewController:imgEditorVC animated:YES completion:nil];
//
//               
//           });
//       }
       [self.delegate LucPhotoHelperGetPhotoSuccess:portraitImg];
   }];
    
}
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        [picker dismissViewControllerAnimated:YES completion:^() {
//            UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//            portraitImg = [self imageByScalingToMaxSize:portraitImg];
//            // 裁剪
//            LucImageCropperViewController *imgEditorVC = [[LucImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, kSCREEN_WIDTH, kSCREEN_WIDTH) limitScaleRatio:3.0];
//            imgEditorVC.delegate = self;
//            if (_target) {
//                [_target presentViewController:imgEditorVC animated:YES completion:^{
//                    // TO DO
//                }];
//            }
//        }];
//        
//    });
//}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [picker dismissViewControllerAnimated:YES completion:nil];
    });
    
}

#pragma mark - VPImageCropperDelegate
- (void)imageCropper:(LucImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    if (_delegate && [_delegate respondsToSelector:@selector(LucPhotoHelperGetPhotoSuccess:)]) {
        [_delegate LucPhotoHelperGetPhotoSuccess:editedImage];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [cropperViewController dismissViewControllerAnimated:YES completion:^{
        }];
    });
}

- (void)imageCropperDidCancel:(LucImageCropperViewController *)cropperViewController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [cropperViewController dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark UIActionSheetDelegate
//{
//    if (buttonIndex == 0) {
//        [self imagePickerStyle:UIImagePickerControllerSourceTypeCamera];
//    }else if (buttonIndex == 1){
//        [self imagePickerStyle:UIImagePickerControllerSourceTypePhotoLibrary];
//    }
//}
//
//- (void)imagePickerStyle:(UIImagePickerControllerSourceType)source
//{
//    if (source == UIImagePickerControllerSourceTypeCamera) {
//        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
//        if (!isCamera) {
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"此设备没有摄像头" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
//            return;
//        }
//    }
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
//    imagePicker.allowsEditing = YES;
//    imagePicker.sourceType = source;
//    imagePicker.delegate = self;
//    if (_target) {
//        [_target presentViewController:imagePicker animated:YES completion:NULL];
//    }
//}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {
        BOOL flag = [YZHelper checkCameraAuthorizationStatus];
        if (flag) {
            NSLog(@"可以使用");
        }else {
            UIAlertView *alertviewPhoto = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在iPhone的“设置->隐私->相机”中打开本应用的访问权限" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertviewPhoto show];
            return;
        }
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isRearCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            if (_target) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //通知主线程刷
                    [_target presentViewController:controller
                                          animated:YES
                                        completion:^(void){
                                        }];
                });
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"该设备不支持拍照" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } else if (buttonIndex == 1) {
        BOOL flag = [YZHelper checkPhotoLibraryAuthorizationStatus];
        if (flag) {
            NSLog(@"可以使用");
        }else {
            UIAlertView *alertviewPhoto = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在iPhone的“设置->隐私->照片”中打开本应用的访问权限" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertviewPhoto show];
            //可尝试隐藏
            return;
        }
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            if (_target) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //通知主线程刷
                    [_target presentViewController:controller
                                          animated:YES
                                        completion:^(void){
                                        }];
                });
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"相册拒绝访问了" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UIApplication *app = [UIApplication sharedApplication];
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([app canOpenURL:settingsURL]) {
            [app openURL:settingsURL];
        }
    }
}
@end

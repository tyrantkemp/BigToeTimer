//
//  UIImage+Util.m
//  iosapp
//
//  Created by ChanAetern on 2/13/15.
//  Copyright (c) 2015 oschina. All rights reserved.
//

#import "UIImage+Util.h"

@implementation UIImage (Util)

// 同 - (UIImage *)jsq_imageMaskedWithColor:(UIColor *)maskColor

- (UIImage *)imageMaskedWithColor:(UIColor *)maskColor
{
    NSParameterAssert(maskColor != nil);
    
    CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextScaleCTM(context, 1.0f, -1.0f);
        CGContextTranslateCTM(context, 0.0f, -(imageRect.size.height));
        
        CGContextClipToMask(context, imageRect, self.CGImage);
        CGContextSetFillColorWithColor(context, maskColor.CGColor);
        CGContextFillRect(context, imageRect);
        
        newImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (UIImage *)cropToRect:(CGRect)rect
{
    CGImageRef imageRef   = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return croppedImage;
}

 - (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
         // 创建一个bitmap的context
     // 并把它设置成为当前正在使用的context
         UIGraphicsBeginImageContext(size);
         // 绘制改变大小的图片
         [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
         // 从当前context中创建一个改变大小后的图片
         UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
         // 使当前的context出堆栈
         UIGraphicsEndImageContext();
     
         // 返回新的改变大小后的图片
         return scaledImage;
     }
@end

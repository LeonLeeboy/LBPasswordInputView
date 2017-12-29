//
//  UIImage+LBPassword.m
//  XSGeneration
//
//  Created by Leon on 2017/12/13.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "UIImage+LBPassword.h"

@implementation UIImage (LBPassword)

+ (instancetype)LB_GridImageViewWithPasswordLength:(NSUInteger)passwordLength borderColor:(UIColor *)color gridWidth:(CGFloat)gridWith lineWidth:(CGFloat)lineWidth{
    CGSize size = CGSizeMake(gridWith * passwordLength, gridWith);
    //1.开启上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    //2.获得上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //3.画图
    CGFloat halfLineWidth = lineWidth / 2.0;
    //画外框
    CGContextMoveToPoint(context, halfLineWidth, halfLineWidth);
    CGContextAddLineToPoint(context, size.width - halfLineWidth, halfLineWidth);
    CGContextAddLineToPoint(context, size.width-halfLineWidth, size.height - halfLineWidth);
    CGContextAddLineToPoint(context, halfLineWidth, size.height - halfLineWidth);
    CGContextAddLineToPoint(context, halfLineWidth, halfLineWidth);
    //画内框
    for (int i = 1; i < passwordLength; i ++) {
        CGContextMoveToPoint(context, gridWith * i, 0);
        CGContextAddLineToPoint(context, gridWith * i, gridWith);
    }
    
    //画线条颜色，设置填充颜色
    [color setStroke];
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    //设置线条宽度
    CGContextSetLineWidth(context, lineWidth);
    // 画
    CGContextDrawPath(context,kCGPathFillStroke);
    
    
    //4.裁剪
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //5. 关闭上下文
    UIGraphicsEndImageContext();
    return image;
}

+ (instancetype)LB_cirleImageWithColor:(UIColor *)contentColor size:(CGSize)size{
    //1.开启上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    //2.获得上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //3.画图
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextAddEllipseInRect(context, rect);
    CGContextSetFillColorWithColor(context, contentColor.CGColor);
    CGContextClip(context);
    //画
    CGContextFillRect(context, rect);
    //4.裁剪
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //5.关闭上下文
    UIGraphicsEndImageContext();
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

@end

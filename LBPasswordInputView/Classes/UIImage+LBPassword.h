//
//  UIImage+LBPassword.h
//  XSGeneration
//
//  Created by Leon on 2017/12/13.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LBPassword)

+ (instancetype)LB_cirleImageWithColor:(UIColor *)contentColor size:(CGSize)size;

+ (instancetype)LB_GridImageViewWithPasswordLength:(NSUInteger)passwordLength borderColor:(UIColor *)color gridWidth:(CGFloat)gridWith lineWidth:(CGFloat)lineWidth;

@end

//
//  LBPasswordInputView.h
//  XSGeneration
//
//  Created by Leon on 2017/12/13.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LBPassWorldDelegate <NSObject>

@optional
- (void)LBPassWordTextField:(NSString *)text complete:(BOOL)complete;

@end

@interface LBPasswordInputView : UIView

@property (weak , nonatomic) id <LBPassWorldDelegate> delegate;

@property (assign , nonatomic , readonly) NSUInteger passWordLength;
/**
 是否是密文形式
 */
@property (assign , nonatomic ,getter=isSecureTextEntry) BOOL secureTextEntry;
/**
 密码
 */
@property (copy , nonatomic , readonly) NSString *password;

+ (instancetype)viewWithPassworldLength:(NSUInteger)length;


@end

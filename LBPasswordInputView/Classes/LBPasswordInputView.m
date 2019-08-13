//
//  LBPasswordInputView.m
//  XSGeneration
//
//  Created by Leon on 2017/12/13.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "LBPasswordInputView.h"
#import "UIImage+LBPassword.h"
#import "UIView+LBPassword.h"



@interface LBPasswordInputView ()

@property (assign, nonatomic, readwrite) NSUInteger passWordLength;

@property (weak, nonatomic ) UIImageView *backgroundImageView;

@property (weak, nonatomic, readwrite) UITextField *pasWordTextField;

/** 是密文的时候的原点ImageView集合 */
@property (strong, nonatomic) NSArray<UIImageView *> *dotsArray;

/** 不是密文的时候，显示文字的label集合 */
@property (strong, nonatomic) NSArray <UILabel *> *labelsArray;

/** 密码原点的颜色 */
@property (strong, nonatomic) UIColor *dotColor;

/** 原点图片的宽度 */
@property (assign, nonatomic) CGFloat dotWidth;

/** gridView 的边框颜色 */
@property (strong, nonatomic) UIColor *borderColor;

/** 边框宽度 */
@property (assign, nonatomic) CGFloat gridLineWidth;

/** 输入了多少个字符 */
@property (assign, nonatomic) NSInteger inputCount;

/** 密码 */
@property (copy, nonatomic, readwrite) NSString *password;

@end



@implementation LBPasswordInputView

static NSString *const LBTextFieldObserverKey = @"UIControlEventEditingChanged";

#pragma mark life cycle
+ (instancetype)viewWithPassworldLength:(NSUInteger)length {
    LBPasswordInputView *passWorldView = [[LBPasswordInputView alloc] init];
    passWorldView.passWordLength = length;
    return passWorldView;
}

/** 初始化,只在xib创建的时候调用 */
- (void)awakeFromNib {
    [super awakeFromNib];
    [self prepare];
}

/** 初始化, 只在代码创建的时候调用 */
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepare];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview: newSuperview];
    [self removeObservers];
    if (newSuperview) {
        [self addObservers];
    }
}

- (void)dealloc {
    [self removeObservers];
}

/** 需要的对应的数据 和 必不可少的UI */
- (void)prepare {
    //初始化数据
    _dotWidth = 10;
    _borderColor = [UIColor darkGrayColor];
    _gridLineWidth = 2.0;
    _secureTextEntry = YES;
    _inputCount = 0;
    _passWordLength = 6;
    //初始化UI
    UITextField *passWordTextField = [[UITextField alloc] init];
    passWordTextField.keyboardType = UIKeyboardTypeNumberPad;
    passWordTextField.tintColor = [UIColor clearColor];
    passWordTextField.textColor = [UIColor clearColor];
    [self addSubview:passWordTextField];
    passWordTextField.secureTextEntry = YES;
    self.pasWordTextField = passWordTextField;
    
    //TextField 的背景 图片
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    [self addSubview:backgroundImageView];
    self.backgroundImageView = backgroundImageView;
    
}

#pragma mark Action
- (void)refreshUIWithPassWord:(NSString *)password{
    //设置隐藏与否
    self.inputCount = password.length;
    // 如果是文字则需要给赋值
    if (self.isSecureTextEntry == NO) {
        for (int i = 0; i < password.length; i ++) {
            UILabel *obj = [self.labelsArray objectAtIndex:i];
            obj.text = [NSString stringWithFormat:@"%c",[password characterAtIndex:i]];
        }
    }
    
}

#pragma mark observers
- (void)removeObservers{
    [self.pasWordTextField removeTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)addObservers{
    [self.pasWordTextField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark delegate
- (void)textChanged:(UITextField *)sender{
    NSString *passWord = sender.text;
    if (passWord.length > self.passWordLength) {
        passWord = [passWord substringToIndex:self.passWordLength];
        sender.text = passWord;
    }
    
    self.password = passWord;
    NSLog(@"文本是：%@",passWord);
    [self refreshUIWithPassWord:passWord];
    if ([self.delegate respondsToSelector:@selector(LBPassWordTextField:complete:)]) {
        BOOL flag = NO;
        if (passWord.length == self.passWordLength) {
            flag = YES;
        }
        [self.delegate LBPassWordTextField:passWord complete:flag];
    }
    
}

#pragma mark layouts
/** 布局 */
- (void)layoutSubviews {
    [self placeSubViews];
    [super layoutSubviews];
}

- (void)placeSubViews {
    //textField Frame
    CGRect passwordFrame = CGRectMake(0, 0, self.LB_width, self.LB_height);
    self.pasWordTextField.frame = passwordFrame;
    //背景 imageView frame
    self.backgroundImageView.frame = CGRectMake(0, 0, self.LB_width, self.LB_height);
    //需要依赖frame 只能放在这里
    self.backgroundImageView.image = [UIImage LB_GridImageViewWithPasswordLength:self.passWordLength borderColor:self.borderColor gridWidth:self.LB_width/self.passWordLength lineWidth:_gridLineWidth];
    CGFloat gridWidth = self.LB_width / self.passWordLength;
    // 小圆点的摆放位置
    for (int i = 0; i < self.dotsArray.count; i++) {
        UIImageView * obj = [self.dotsArray objectAtIndex:i];
        CGFloat w = self.dotWidth;
        CGFloat h = w;
        CGFloat x = gridWidth/2.0 - w/2.0 + gridWidth * i;
        CGFloat y = self.LB_height / 2.0 - h/2.0;
        CGRect frame = CGRectMake(x, y, w,h );
        obj.frame = frame;
    }
    // 不是密文的Labels  frame
    for (int i = 0; i < self.labelsArray.count; i ++) {
        
        UILabel *label = [self.labelsArray objectAtIndex:i];
        
        CGFloat labX = i * gridWidth;
        CGFloat labY = 0;
        CGFloat labW = gridWidth;
        CGFloat labH = self.LB_height;
        CGRect labFrame = CGRectMake(labX, labY, labW, labH);
        
        label.frame = labFrame;
    }
    
}

#pragma mark getter && setter
/** 懒加载密文情况下的UIImageVie Array */
- (NSArray<UIImageView *> *)dotsArray{
    if (_dotsArray == nil) {
        NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:self.passWordLength];
        for (int i = 0; i<self.passWordLength; i++) {
            UIImage *dotImage = [UIImage LB_cirleImageWithColor:self.dotColor size:CGSizeMake(self.dotWidth, self.dotWidth)];
            UIImageView *dotImageView = [[UIImageView alloc] initWithImage:dotImage];
            [dataSource addObject:dotImageView];
            [self addSubview:dotImageView];
        }
        _dotsArray = dataSource.copy;
    }
    return _dotsArray;
}


/** 懒加载不是密文的Label Array */
- (NSArray<UILabel *> *)labelsArray{
    if (_labelsArray == nil) {
        NSMutableArray *dataSource  = [NSMutableArray arrayWithCapacity:self.passWordLength];
        for (int i = 0; i < self.passWordLength; i++) {
            UILabel *lab = [[UILabel alloc] init];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = self.dotColor;
            lab.font = [UIFont systemFontOfSize:14];
            [self addSubview:lab];
            [dataSource addObject:lab];
        }
        _labelsArray = dataSource.copy;
    }
    return _labelsArray;
}

- (void)setPassWordLength:(NSUInteger)passWordLength{
    
    _passWordLength = passWordLength;
    self.inputCount = self.pasWordTextField.text.length;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry{
    if (secureTextEntry == _secureTextEntry) {
        return;
    }
    _secureTextEntry = secureTextEntry;
    self.pasWordTextField.secureTextEntry = secureTextEntry;
    self.inputCount = self.pasWordTextField.text.length;
}

- (void)setInputCount:(NSInteger)inputCount{
    if (inputCount == _inputCount) {
        if (inputCount != 0) {
            return;
        }
        
    }
    _inputCount = inputCount;
    if (self.isSecureTextEntry == true) {
        //是密文 隐藏所有labels ， 显示输入的个数的原点，剩下的隐藏
        [self.labelsArray enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = YES;
        }];
        for (int i = 0; i < inputCount; i ++) {
            UIImageView *obj = [self.dotsArray objectAtIndex:i];
            obj.hidden = NO;
        }
        for (NSInteger i = inputCount; i < self.dotsArray.count; i++) {
            UIImageView *obj = [self.dotsArray objectAtIndex:i];
            obj.hidden = YES;
        }
    }else{
        //是明文 隐藏所有iamgeView 圆点，显示输入个数的Label，剩下的全隐藏
        [self.dotsArray enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = YES;
        }];
        for (NSInteger i = 0; i < inputCount; i++) {
            UILabel *obj = [self.labelsArray objectAtIndex:i];
            obj.hidden = NO;
        }
        
        for (NSInteger i = inputCount; i < self.labelsArray.count; i ++) {
            UILabel *obj = [self.labelsArray objectAtIndex:i];
            obj.hidden = YES;
        }
    }
}

@end

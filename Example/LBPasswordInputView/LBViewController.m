//
//  LBViewController.m
//  LBPasswordInputView
//
//  Created by j1103765636@iCloud.com on 12/14/2017.
//  Copyright (c) 2017 j1103765636@iCloud.com. All rights reserved.
//

#import "LBViewController.h"

#import <LBPasswordInputView/LBPasswordInputView.h>
#import <LBPasswordInputView/UIView+LBPassword.h>

@interface LBViewController ()

@end

@implementation LBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    LBPasswordInputView *passw = [LBPasswordInputView viewWithPassworldLength:6];
    passw.LB_x = 10;
    passw.LB_height = 54;
    passw.LB_y = ([UIScreen mainScreen].bounds.size.height - passw.LB_y )/2.0;
    passw.LB_width = [UIScreen mainScreen].bounds.size.width - 2 * passw.LB_x;
    passw.secureTextEntry = NO;
    
    [self.view addSubview:passw];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

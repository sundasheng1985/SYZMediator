//
//  SYZDetailViewController.m
//  SYZMediator_Example
//
//  Created by sun on 2019/3/14.
//  Copyright © 2019年 sundasheng1985. All rights reserved.
//

#import "SYZDetailViewController.h"
#import <SYZMultipleUIKit/SYZMultipleUIKit.h>

@interface SYZDetailViewController ()

@end

@implementation SYZDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = self.view.bounds;
    [btn setTitle:@"点击空页面回去" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)buttonAction:(UIButton *)sender{
    [self syz_dismissOrPop:YES];
}

@end

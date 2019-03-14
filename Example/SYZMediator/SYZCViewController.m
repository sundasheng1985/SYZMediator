//
//  SYZCViewController.m
//  SYZMediator_Example
//
//  Created by sun on 2019/3/14.
//  Copyright © 2019年 sundasheng1985. All rights reserved.
//

#import "SYZCViewController.h"
#import <SYZMultipleUIKit/SYZMultipleUIKit.h>
@interface SYZCViewController ()

@end

@implementation SYZCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"跳到c";
    self.view.backgroundColor = [UIColor whiteColor];
    __block SYZCViewController *weakself = self;
    [self.view syz_addTapGestureWithHandler:^(id sender) {
        [weakself syz_dismissOrPop:YES];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

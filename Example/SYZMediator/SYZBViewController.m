//
//  SYZBViewController.m
//  SYZMediator_Example
//
//  Created by sun on 2019/3/14.
//  Copyright © 2019年 sundasheng1985. All rights reserved.
//

#import "SYZBViewController.h"
#import <SYZUIBasekit/SYZUIBasekit.h>

@interface SYZBViewController ()
@property (nonatomic,copy) NSString* someId;
@property (nonatomic,copy) SYZCallback callback;@end

@implementation SYZBViewController

- (instancetype)initWithId:(NSString *)someId callback:(SYZCallback)callback {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.someId = someId;
        self.callback = callback;
        NSLog(@"callback:  %@",self.callback);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [@"bbb  " stringByAppendingString:SYZNoNilString(self.someId)];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点击回调" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.center = self.view.center;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnAction:(UIButton*)sender {
    if (self.callback) {
        self.callback(@"这是回调哦");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 实现这个表示是present出来的 */
- (SYZPageTransitionType)transitionTypeForContext:(SYZRouterContext *)context {
    return SYZPageTransitionTypePresent;
}



@end

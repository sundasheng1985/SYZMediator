//
//  SYZAViewController.m
//  SYZMediator_Example
//
//  Created by sun on 2019/3/14.
//  Copyright © 2019年 sundasheng1985. All rights reserved.
//

#import "SYZAViewController.h"
#import <SYZUIBasekit/SYZUIBasekit.h>
@interface SYZAViewController ()
@property (nonatomic,strong) NSString* someId;
@end

@implementation SYZAViewController

- (instancetype)initWithId:(NSString *)someId {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.someId = someId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [@"我是A  " stringByAppendingString:self.someId];
    self.view.backgroundColor = [UIColor whiteColor];
}


@end

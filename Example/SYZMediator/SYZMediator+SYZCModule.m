//
//  SYZMediator+SYZCModule.m
//  SYZMediator_Example
//
//  Created by sun on 2019/3/14.
//  Copyright © 2019年 sundasheng1985. All rights reserved.
//

#import "SYZMediator+SYZCModule.h"

NSString * const KSYZMediatorC_target = @"c";
NSString * const KSYZMediatorC_main = @"main";
@implementation SYZMediator (SYZCModule)

- (void)main_open {
    [self openPackage:[self c_mainPackage]];
}

- (SYZRouterPackage *)c_mainPackage{
    SYZRouterPackage* package = [SYZRouterPackage new];
    package.target = KSYZMediatorC_target;
    package.action = KSYZMediatorC_main;
    return package;
}

- (UIViewController *)c_mainPack{
    return [self performTarget:KSYZMediatorC_target action:KSYZMediatorC_main params:nil];
}

- (NSString *)c_mainLink{
    return [self makeShortLink:KSYZMediatorC_target action:KSYZMediatorC_main params:nil];
}

@end

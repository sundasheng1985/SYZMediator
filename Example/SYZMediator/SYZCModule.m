//
//  SYZCModule.m
//  SYZMediator_Example
//
//  Created by sun on 2019/3/14.
//  Copyright © 2019年 sundasheng1985. All rights reserved.
//

#import "SYZCModule.h"
#import "SYZMediator+SYZCModule.h"
#import "SYZCViewController.h"
@implementation SYZCModule

SYZ_Export_Module(c)

- (id)Action_main:(SYZRouterContext *)context{
    return [SYZCViewController new];
}

@end

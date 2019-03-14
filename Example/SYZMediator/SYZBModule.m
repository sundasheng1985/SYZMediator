//
//  SYZBModule.m
//  SYZMediator_Example
//
//  Created by sun on 2019/3/14.
//  Copyright © 2019年 sundasheng1985. All rights reserved.
//

#import "SYZBModule.h"
#import "SYZBViewController.h"

@implementation SYZBModule
SYZ_Export_Module(b)

- (void)modSetup:(SYZRouterContext *)context {
    NSLog(@"bbbbbbbbbb");
}

- (void)notFound:(SYZRouterContext *)context {
    NSLog(@"params: %@",context.customParams);
}

- (id)Action_detail:(SYZRouterContext *)context {
    UIViewController* vc = [[SYZBViewController alloc] initWithId:context.customParams[@"someId"] callback:context.customParams[@"callback"]];
    [self unregister];
    return [[UINavigationController alloc] initWithRootViewController:vc];
}
@end

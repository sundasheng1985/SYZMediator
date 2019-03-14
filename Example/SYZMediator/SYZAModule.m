//
//  SYZAModule.m
//  SYZMediator_Example
//
//  Created by sun on 2019/3/14.
//  Copyright © 2019年 sundasheng1985. All rights reserved.
//

#import "SYZAModule.h"
#import "SYZAViewController.h"

@implementation SYZAModule
/** 标识名称 */
SYZ_Export_Module(a)

- (void)modSetup:(SYZRouterContext *)context {
    NSLog(@"aaaaaaaaa");
}

- (id)Action_detail:(SYZRouterContext *)context {
    NSArray<NSString*>* rets = context.customParams[@"ids"];
    for (NSString* str in rets) {
        NSLog(@"%@",str);
    }
    SYZAViewController* vc = [[SYZAViewController alloc] initWithId:context.customParams[@"id"]];
    return vc;
}


/** 实现这个表示那些action事件需要登录 */
- (NSArray<NSString *> *)actionsNeedLogin {
//    return @[@"detail"];
    return @[];
}


/** 权限 */
- (NSArray<NSString *> *)actionNeedPermission {
//    return @[@"detail"];
    return @[];
}
@end

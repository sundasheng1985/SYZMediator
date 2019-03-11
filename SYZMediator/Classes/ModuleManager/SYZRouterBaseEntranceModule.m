//
//  SYZRouterBaseEntranceModule.m
//  SYZMediator
//
//  Created by sundasheng1985 on 03/10/2019.
//

#import "SYZRouterBaseEntranceModule.h"
#import <objc/runtime.h>
#import "SYZMediator.h"

@implementation SYZRouterBaseEntranceModule

- (void)modSetup:(SYZRouterContext *)context {

}

- (void)notFound:(SYZRouterContext *)context {

}

/** 模块名*/
- (NSArray<NSString*>*)moduleNames {
    NSAssert(nil, @"子模块必须实现 moduleNames方法，请检查exportModule是否写成了 SYZ_Export_Modules()");
    return @[];
}

+ (void)registerSelf {
    [SYZMediator registerModule:[self class]];
}

- (void)unregister {
    [SYZGlobalMediator unregisterModule:self];
}

- (void)reRegister {
    [self unregister];
    [[self class] registerSelf];
}

- (void)modDealloc:(SYZRouterContext *)context {
    
}

- (NSArray<NSString *> *)actionsNeedLogin {
    return @[];
}

- (BOOL)accessDependencyByLogin:(SYZRouterContext *)context {
    return [[self actionsNeedLogin] containsObject:context.action];
}

- (NSArray<NSString *> *)actionNeedPermission {
    return @[];
}

- (BOOL)accessDependencyByPermission:(SYZRouterContext *)context {
    NSArray *actions = [self actionNeedPermission];
    if (SYZIsEmptyArray(actions)) return YES;
    return [actions containsObject:context.action];
}

- (void)buildConditionsForVisitAction:(SYZRouterContext *)context {
    
}

@end

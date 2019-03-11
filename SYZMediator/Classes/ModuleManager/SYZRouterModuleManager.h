//
//  SYZRouterModuleManager.h
//  SYZMediator
//
//  Created by sundasheng1985 on 03/10/2019.
//

#import <Foundation/Foundation.h>
#import <SYZUIBasekit/SYZUIBasekit.h>
#import "SYZRouterBaseEntranceModule.h"

/** 模块管理*/
@interface SYZRouterModuleManager : NSObject
SYZSingletonInterface()

- (void)registerModule:(Class)module;
- (void)unregisterModule:(SYZRouterBaseEntranceModule*)module;

- (NSArray<SYZRouterBaseEntranceModule*>*)allModules;

- (SYZRouterBaseEntranceModule*)moduleByName:(NSString*)name;

/**
 额外注册 target-action，规则不变，target 和 action全部小写，如果target-action已存在，优先调用handler
 如： [SYZGlobalMediator registerTarget:@"aaa" action:@"bbb" handler:id(^)(id){}];
 */
- (void)registerTarget:(NSString*)aTarget action:(NSString*)aAction handler:(SYZOneParamReturnCallback)handler;
/** 注销所有相关target-action*/
- (void)unregisterTarget:(NSString*)aTarget;
- (void)unregisterTarget:(NSString*)aTarget action:(NSString*)aAction;
- (SYZOneParamReturnCallback)handlerForTarget:(NSString*)aTarget action:(NSString*)aAction;

@end

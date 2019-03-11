//
//  SYZRouterBaseEntranceModule.h
//  SYZMediator
//
//  Created by sundasheng1985 on 03/10/2019.
//

#import <Foundation/Foundation.h>
#import "SYZRouterContext.h"
#import "SYZMediatorMacros.h"

/**
 注册/移除 模块
 */

/** 模块入口
 所有模块的必须继承该类
 */
@interface SYZRouterBaseEntranceModule : NSObject

- (void)modSetup:(SYZRouterContext*)context;

- (void)notFound:(SYZRouterContext*)context;

/** 组件即将取消注册*/
- (void)modDealloc:(SYZRouterContext*)context;

/** 模块名*/
- (NSArray<NSString*>*)moduleNames;

+ (void)registerSelf;
- (void)unregister;
- (void)reRegister;

/** 返回需要登录的Actions */
- (NSArray<NSString *> *)actionsNeedLogin;

/** 根据参数判断是否需要登录 */
- (BOOL)accessDependencyByLogin:(SYZRouterContext *)context;

/** 返回需要权限判断的Actions */
- (NSArray<NSString *> *)actionNeedPermission;

/** 根据参数判断是否能进入下一步 */
- (BOOL)accessDependencyByPermission:(SYZRouterContext *)context;

/** 访问action需要的条件，使用context.conditionBuilder进行添加
 该条件由具体项目进行定义，为NSString类型，可为多个条件
 如果返回的条件为空数组，则认为可以直接访问
 否则mediator会携带这些条件询问intercepter拦截器这些条件是否满足，如果有一条不满足，则该次路由暂停，可使用context.redo方法再次执行路由
 */
- (void)buildConditionsForVisitAction:(SYZRouterContext*)context;


@end

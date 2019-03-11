//
//  ISYZMediatorIntercepter.h
//  SYZMediator
//
//  Created by majian on 2019/1/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SYZMediator;
@class SYZRouterContext;
/** 对mediator事件进行拦截，是否做登录检测、角色鉴权等*/
@protocol ISYZMediatorIntercepter <NSObject>

/** 是否满足某项条件*/
- (BOOL)mediator:(SYZMediator*)mediator intercepterProcess:(SYZRouterContext*)context requireCndition:(NSString*)aCondition;

/** 因为某项条件未满足，会调用该方法*/
- (void)mediator:(SYZMediator*)mediator intercepedContext:(SYZRouterContext*)context requireCndition:(NSString*)aCondition;

/** 可以进行处理的权限*/
- (NSArray<NSString*>*)intercepteConditions;

@end

NS_ASSUME_NONNULL_END

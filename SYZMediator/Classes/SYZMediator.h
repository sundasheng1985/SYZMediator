//
//  SYZMediator.h
//  MediatorDemo
//
//  Created by sundasheng1985 on 03/10/2019.
//  Copyright (c) 2019 sundasheng1985. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SYZUIBasekit/SYZUIBasekit.h>
#import "SYZViewControllerTransitionProtocol.h"
#import "SYZRouterPackage.h"
#import "SYZRouterBaseEntranceModule.h"
#import "ISYZMediatorIntercepter.h"

typedef NS_ENUM(NSUInteger,SYZMediatorErrorReason) {
    SYZMediatorErrorReasonNoTarget,
    SYZMediatorErrorReasonActionNotImp,
    SYZMediatorErrorReasonParameterError, //参数错误，如aTarget或者aAction为空
};

@class SYZMediator;
@protocol SYZMediatorDelegate <NSObject>

/**
 *  中转发生错误时回调
 *  @discussion
 *          当aErrorReason == SYZMediatorErrorReasonParameterError 时，aInfoParams为nil
 *          否则aInfoParams的格式为{
                                    "target":target,
                                    "action":action
                                 }
 *
 */
- (UIViewController *)mediator:(SYZMediator *)aMediator notFoundComponentsWithReason:(SYZMediatorErrorReason)aErrorReason info:(NSDictionary *)aInfoParams;

@end

@protocol SYZMediatorLoginDelegate <NSObject>
@required
/** 检查是否已经登录 */
- (BOOL)mediatorCheckIsLogin;

@optional
/** 通知进行登录操作 */
- (void)mediatorNotificationNeedToLogin:(SYZRouterContext *)context;
@end


#ifndef SYZGlobalMediator
#define SYZGlobalMediator [SYZMediator sharedMediator]
#endif

@interface SYZMediator : NSObject

+ (SYZMediator *)sharedMediator;

@property (nonatomic,copy) NSString * appSchema;
@property (nonatomic, weak) id<SYZMediatorLoginDelegate> mediatorLoginDelegate;

- (void)setErrorResponer:(id<SYZMediatorDelegate>)aErrorResponser;

- (id)performTarget:(NSString *)aTarget
             action:(NSString *)aAction
             params:(NSDictionary *)aParams;

/**
 支持app内模块跳转及应用间跳转
 如果是网页,如: https://www.xxx.com/ 则会使用safari打开
 如果是非标准网页格式，如 www.xxx.com   则会被忽视
 其他情况，必须以当前应用的schema开头
 一切app内或系统无法响应的url都会被忽视
 */
- (id)openURL:(NSURL *)url completion:(void (^)(NSDictionary *))completion;
- (id)openURL:(NSURL *)url;
- (id)openURLString:(NSString *)url completion:(void(^)(NSDictionary *))completion;
- (id)openURLString:(NSString *)url;

/** 限于内部打开url，如果是从safari或者其他app进入的，请使用openURLString:*/
- (id)openInnerURLString:(NSString*)url;

/** 由Mediator分类根据用户提供的参数进行分装，类似String类型的link*/
- (void)openPackage:(SYZRouterPackage*)package;
- (void)openPackageWithTarget:(NSString*)target action:(NSString*)action params:(NSDictionary*)params;

/**
 额外注册 target-action，规则不变，target 和 action全部小写，如果target-action已存在，优先调用handler,入参依然为SYZRouterContext
 如： [SYZGlobalMediator registerTarget:@"aaa" action:@"bbb" handler:id(^)(id){}];
 */
- (void)registerTarget:(NSString*)aTarget action:(NSString*)aAction handler:(SYZOneParamReturnCallback)handler;
/** 注销所有相关target-action*/
- (void)unregisterTarget:(NSString*)aTarget;
- (void)unregisterTarget:(NSString*)aTarget action:(NSString*)aAction;

/** 对context进行处理*/
- (id)routeContext:(SYZRouterContext*)context;

/** 支持跳转链接重定向 */
- (void)addOrUpdateRedirectLinks:(NSDictionary *)redirectLinks;
/** 单个更新重定向*/
- (void)addOrUpdateLink:(NSString *)oldLink toLink:(NSString *)newLink;
/** 不再支持链接重定向*/
- (void)removeRedirectLinks;
/** 获取当前的重定向链接*/
- (NSDictionary *)allRedirectLinks;
/** 当前显示的页面*/
- (UIViewController*)currentViewController;
/** rootVC*/
- (UIViewController*)currentRootViewController;

/** 生成链接的快捷方式*/
- (NSString*)makeShortLink:(NSString*)moduleName action:(NSString*)actionName params:(NSDictionary*)params;

/** 注册模块*/
+ (void)registerModule:(Class)module;
/** 移除模块*/
- (void)unregisterModule:(SYZRouterBaseEntranceModule*)module;

#pragma mark - 拦截器
/** 添加拦截器*/
- (void)addIntercepter:(id<ISYZMediatorIntercepter>)intercepter;
/** 移除拦截器*/
- (void)removeIntercepter:(id<ISYZMediatorIntercepter>)intercepter;
@end

extern NSString * const kSYZMediatorTargetKey; //target
extern NSString * const kSYZMediatorActionKey; //action







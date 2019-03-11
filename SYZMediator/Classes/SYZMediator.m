//
//  SYZMediator.m
//  MediatorDemo
//
//  Created by sundasheng1985 on 03/10/2019.
//  Copyright (c) 2019 sundasheng1985. All rights reserved.
//

#import "SYZMediator.h"
#import "SYZRouterModuleManager.h"

NSString* const kSYZMediatorTargetKey = @"target";
NSString* const kSYZMediatorActionKey = @"action";

@interface SYZMediator () {
    id<SYZMediatorDelegate> _errorResponser;
}

@property (nonatomic,strong) NSDictionary * redirectLinks;
/** 存储拦截器*/
@property (nonatomic,strong) NSMutableArray* intercepters;
@property (nonatomic,strong) NSMutableDictionary* interceptersDict;
@end

@implementation SYZMediator

+ (SYZMediator *)sharedMediator {
    static SYZMediator * _defaultMediator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultMediator = [[SYZMediator alloc] init];
    });

    return _defaultMediator;
}

- (void)setErrorResponer:(id<SYZMediatorDelegate>)aErrorResponser {
    if (aErrorResponser != nil && aErrorResponser != _errorResponser) {
        _errorResponser = aErrorResponser;
    }
}

- (id)_performTarget:(NSString*)aTarget action:(NSString*)aAction params:(NSDictionary*)aParams autoJump:(BOOL)autoJump {
    if (SYZIsEmptyString(aTarget) || SYZIsEmptyString(aAction)) {
        if ([_errorResponser respondsToSelector:@selector(mediator:notFoundComponentsWithReason:info:)]) {
            return [_errorResponser mediator:self
                notFoundComponentsWithReason:SYZMediatorErrorReasonParameterError
                                        info:nil];
        }
        return nil;
    }

    SYZRouterContext *context = [SYZRouterContext sharedInstance].copy;
    context.target = [aTarget lowercaseString];
    context.action = [aAction lowercaseString];
    context.customParams = aParams;
    context.autoRoute = autoJump;
    return [self routeContext:context];
}

- (void)addIntercepter:(id<ISYZMediatorIntercepter>)intercepter {
    NSArray* conditions = [intercepter intercepteConditions];
    for (NSString* aCondition in conditions) {
        self.interceptersDict[aCondition] = intercepter;
    }
}

- (void)removeIntercepter:(id<ISYZMediatorIntercepter>)intercepter {

}

/** 对context进行处理*/
- (id)routeContext:(SYZRouterContext*)context {
    SYZOneParamReturnCallback handler = [[SYZRouterModuleManager sharedInstance] handlerForTarget:context.target action:context.action];
    if (handler) {
        id retObj = handler(context);
        if ([retObj isKindOfClass:[UIViewController class]] && context.autoRoute) {
            [self _transferPage:retObj context:context];
        }
        return retObj;
    }

    SYZRouterBaseEntranceModule *module = [[SYZRouterModuleManager sharedInstance] moduleByName:context.target];
    if (module == nil) return nil;

    //获取访问action需要的auths
    if (context.requireBuildCondition) { //防止context执行redo时重复进行build
        [module buildConditionsForVisitAction:context];
    }
    NSArray<NSString*>* conditions = context.conditions;
    if (conditions.count > 0) {
        //询问intercepter是否可以进行路由
        if (![self _canRoute:context conditions:conditions]) return nil;
    }

    return [self _doRoute:context module:module];
}

/** 询问所有intercepters*/
- (BOOL)_canRoute:(SYZRouterContext*)context conditions:(NSArray<NSString*>*)conditions {
    for (NSString* aAuth in conditions) {
        id<ISYZMediatorIntercepter> intercepter = self.interceptersDict[aAuth];
        if (intercepter) {
            BOOL valid = [intercepter mediator:self intercepterProcess:context requireCndition:aAuth];
            if (valid == NO) {
                [intercepter mediator:self intercepedContext:context requireCndition:aAuth];
                return NO;
            }
        } else {
            NSMutableDictionary* userInfos = [NSMutableDictionary new];
            userInfos[@"target"] = context.target;
            userInfos[@"action"] = context.action;
            [NSException exceptionWithName:@"SYZMediator异常" reason:@"权限未进行检测" userInfo:userInfos];
                //如果对某项权限没有进行验证，则返回NO
            return NO;
        }
    }

    return YES;
}

- (id)_doRoute:(SYZRouterContext*)context module:(SYZRouterBaseEntranceModule*)module {
    NSString * actionString = [NSString stringWithFormat:@"Action_%@:",context.action];
    SEL actionSelector = NSSelectorFromString(actionString);

    if ([module respondsToSelector:actionSelector]) {
        id retObj = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        retObj = [module performSelector:actionSelector withObject:context];
#pragma clang diagnostic pop

        if ([retObj isKindOfClass:[UIViewController class]] && context.autoRoute) {
            [self _transferPage:retObj context:context];
        }
        return retObj;
    } else {
        [module notFound:context];
    }

    return nil;
}

/**
 额外注册 target-action，规则不变，target 和 action全部小写，如果target-action已存在，优先调用handler
 如： [SYZGlobalMediator registerTarget:@"aaa" action:@"bbb" handler:id(^)(id){}];
 */
- (void)registerTarget:(NSString*)aTarget action:(NSString*)aAction handler:(SYZOneParamReturnCallback)handler {
    [[SYZRouterModuleManager sharedInstance] registerTarget:aTarget action:aAction handler:handler];
}

- (void)unregisterTarget:(NSString*)aTarget {
    [[SYZRouterModuleManager sharedInstance] unregisterTarget:aTarget];
}

- (void)unregisterTarget:(NSString*)aTarget action:(NSString*)aAction {
    [[SYZRouterModuleManager sharedInstance] unregisterTarget:aTarget action:aAction];
}

- (id)performTarget:(NSString *)aTarget action:(NSString *)aAction params:(NSDictionary *)aParams {
    return [self _performTarget:aTarget action:aAction params:aParams autoJump:NO];
}

- (void)openPackage:(SYZRouterPackage*)package {
    [self _performTarget:package.target action:package.action params:package.params autoJump:YES];
}

- (void)openPackageWithTarget:(NSString*)target action:(NSString*)action params:(NSDictionary*)params {
    [self openPackage:[SYZRouterPackage poackageWithTarget:target action:action params:params]];
}

/*
 scheme://[target]/[action]?[params]
 url sample:
 aaa://targetA/actionB?id=1234
 */
- (id)openURLString:(NSString *)url completion:(void (^)(NSDictionary *))completion {
    return [self openURL:[url syz_toURL] completion:completion];
}

- (id)openURLString:(NSString *)url {
    return [self openURLString:url completion:nil];
}

/** 限于内部打开url，如果是从safari或者其他app进入的，请使用openURLString:*/
- (id)openInnerURLString:(NSString*)url {
    NSURL* aURL = url.syz_toURL;
    if (SYZIsEmptyString(aURL.scheme)) {
        aURL = [[self.appSchema stringByAppendingFormat:@"://%@",url] syz_toURL];
    }
    return [self openURL:aURL completion:nil];
}

- (id)openURL:(NSURL *)url {
    return [self openURL:url completion:nil];
}

- (id)openURL:(NSURL *)url completion:(void (^)(NSDictionary *))completion {
    if (![url.scheme isEqualToString:self.appSchema]) {
        // 这里就是针对远程app调用404的简单处理了，根据不同app的产品经理要求不同，你们可以在这里自己做需要的逻辑
        //如果不是本app可以处理的链接，则尝试让系统进行处理，用于打开对应app进行处理
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
        return nil;
    }

        //重定向
    if (SYZIsNotEmptyDictionary(self.redirectLinks) && [self.redirectLinks syz_containsKey:[[url.host lowercaseString] stringByAppendingString:[url.path lowercaseString]]]) {
        NSString * oldPath = [url.host stringByAppendingString:url.path];
        NSString * urlString = url.absoluteString;
        NSString * newUrlString = [urlString stringByReplacingOccurrencesOfString:oldPath withString:self.redirectLinks[oldPath]];
        NSURLComponents * urlComponents = [NSURLComponents componentsWithString:newUrlString];
        url = urlComponents.URL;
    }

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *urlString = [url query];
    if (SYZIsNotEmpty(urlString) && [urlString rangeOfString:@"http"].location != NSNotFound) {
        NSError * error = nil;
        NSDataDetector * dataDetector = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink
                                                                        error:&error];
        NSArray<NSTextCheckingResult *> * results = [dataDetector matchesInString:urlString options:0 range:NSMakeRange(0, urlString.length)];
        if (results.count > 0) {
            NSRange range = results.firstObject.range;
            if (range.location != NSNotFound) {
                NSString * link = [urlString substringWithRange:range];
                if (range.location - 1 > 0 ) {
                    NSString * key = [urlString substringToIndex:range.location - 1];
                    if (SYZIsNotEmpty(link) && SYZIsNotEmpty(key)) {
                        [params setObject:[[link syz_replacingPercentEscapes] syz_replacingPercentEscapes] forKey:key];
                    }
                }
            }
        }
    } else {
        for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
            NSArray *elts = [param componentsSeparatedByString:@"="];
            if([elts count] < 2) continue;
            [params setObject:[[[elts lastObject] syz_replacingPercentEscapes] syz_replacingPercentEscapes] forKey:[elts firstObject]];
        }
    }
    // 这里这么写主要是出于安全考虑，防止黑客通过远程方式调用本地模块。这里的做法足以应对绝大多数场景，如果要求更加严苛，也可以做更加复杂的安全逻辑。
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"native"]) {
        return nil;
    }

    if (SYZIsNotEmptyDictionary(params)) {
        params = [params syz_toJsonObject];
    }
    // 这个demo针对URL的路由处理非常简单，就只是取对应的target名字和method名字，但这已经足以应对绝大部份需求。如果需要拓展，可以在这个方法调用之前加入完整的路由逻辑
    id result = [self _performTarget:[url.host lowercaseString] action:[actionName lowercaseString] params:params autoJump:YES];
    if (completion) {
        if (result) {
            completion(@{@"result":result});
        } else {
            completion(nil);
        }
    }
    return result;
}

/** 支持跳转链接重定向 */
- (void)addOrUpdateRedirectLinks:(NSDictionary *)redirectLinks {
    if (SYZIsEmptyDictionary(redirectLinks)) {
        [self removeRedirectLinks];
    } else {
        @synchronized (self) {
            if (self.redirectLinks == nil) {
                self.redirectLinks = [redirectLinks copy];
            } else {
                self.redirectLinks = [self.redirectLinks syz_appendingDictionary:redirectLinks];
            }
        }
    }
}

- (void)addOrUpdateLink:(NSString *)oldLink toLink:(NSString *)newLink {
    if (SYZIsEmptyString(oldLink) || SYZIsEmptyString(newLink)) {
        return;
    }

    @synchronized (self) {
        NSMutableDictionary * tempReLinks = [self.redirectLinks mutableCopy];
        tempReLinks[oldLink] = newLink;
        self.redirectLinks = [tempReLinks copy];
    }
}

/**
 不再支持链接重定向
 */
- (void)removeRedirectLinks {
    @synchronized (self) {
        self.redirectLinks = nil;
    }
}

- (NSDictionary *)allRedirectLinks {
    NSDictionary * reLinks = nil;
    @synchronized (self) {
        reLinks = [_redirectLinks copy];
    }
    return reLinks;
}

/** 跳转页面*/
- (void)_transferPage:(UIViewController*)targetController context:(SYZRouterContext*)context{
    SYZPageTransitionType transitionType = SYZPageTransitionTypePush;
    UIViewController* _target = [self _findTargetViewController:targetController];
    if ([_target conformsToProtocol:@protocol(SYZViewControllerTransitionProtocol)]) {
        id<SYZViewControllerTransitionProtocol> targetVC = (id<SYZViewControllerTransitionProtocol>)_target;
        if (SYZIsRespondsToSelector(targetVC, @selector(transitionTypeForContext:))) {
            transitionType = [targetVC transitionTypeForContext:context];
        }
    }

    if (transitionType == SYZPageTransitionTypePresent) {
        [[self currentViewController] presentViewController:targetController animated:YES completion:nil];
    } else {
        [[self currentViewController].navigationController pushViewController:targetController animated:YES];
    }
}

- (UIViewController*)_findTargetViewController:(UIViewController*)viewController {
    UIViewController* targetViewController = viewController;
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        targetViewController = ((UINavigationController*)viewController).topViewController;
    }
    return targetViewController;
}

/** 当前显示的页面*/
- (UIViewController*)currentViewController {
    UIViewController* viewController = [self currentRootViewController];
    while (viewController) {
        if ([viewController isKindOfClass:[UITabBarController class]]) {
            viewController = ((UITabBarController*)viewController).selectedViewController;
        } else if ([viewController isKindOfClass:[UINavigationController class]]) {
            viewController = ((UINavigationController*)viewController).topViewController;
        } else if (viewController.presentedViewController) {
            viewController = viewController.presentedViewController;
        } else {
            return viewController;
        }
    }

    return viewController;
}

- (UIViewController*)currentRootViewController {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

/** 注册模块*/
+ (void)registerModule:(Class)module {
    [[SYZRouterModuleManager sharedInstance] registerModule:module];
}

/** 移除模块*/
- (void)unregisterModule:(SYZRouterBaseEntranceModule*)module {
    [[SYZRouterModuleManager sharedInstance] unregisterModule:module];
}

/** 生成链接的快捷方式*/
- (NSString*)makeShortLink:(NSString*)moduleName action:(NSString*)actionName params:(NSDictionary*)params {
    if (SYZIsEmptyString(moduleName) || SYZIsEmptyString(actionName)) return @"";
//    NSString* retLink = [NSString stringWithFormat:@"%@://%@/%@",self.appSchema,moduleName,actionName];
    NSURLComponents* urlComponents = [NSURLComponents new];
    urlComponents.scheme = self.appSchema;
    urlComponents.host = moduleName;
    urlComponents.path = [@"/" stringByAppendingString:actionName];
    if (SYZIsNotEmptyDictionary(params)) {
        NSMutableArray* queryItems = [NSMutableArray new];
        [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSURLQueryItem* item = [NSURLQueryItem queryItemWithName:[key syz_toString] value:[obj syz_tocURLFormat]];
            [queryItems addObject:item];
        }];
        urlComponents.queryItems = queryItems;
    }

//    if (SYZIsEmptyDictionary(params)) {
//        NSMutableArray<NSString*> *paramsString = [NSMutableArray new];
//        [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//            NSString* paramString = [NSString stringWithFormat:@"%@=%@",key,obj];
//            [paramsString addObject:paramString];
//        }];
//        if (paramsString.count > 0) {
//            retLink = [retLink stringByAppendingString:@"?"];
//            if (paramsString.count > 1) {
//
//            }
//        }
//    }
    return urlComponents.URL.absoluteString;
}

SYZLazyCreateMutableArray(intercepters)
SYZLazyCreateMutableDictionary(interceptersDict)

@end






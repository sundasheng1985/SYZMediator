//
//  SYZRouterModuleManager.m
//  SYZMediator
//
//  Created by sundasheng1985 on 03/10/2019.
//

#import "SYZRouterModuleManager.h"

static NSString* const SYZ_ROUTER_CLASS = @"moduleClass";
static NSString* const SYZ_ROUTER_NAME = @"moduleName";

@interface SYZRouterModuleManager()

@property (nonatomic,strong) NSMutableDictionary* modulesInfo;
@property (nonatomic,strong) NSMutableDictionary* allDynamicModule;

@property (nonatomic,strong) NSMutableDictionary<NSString*,SYZOneParamReturnCallback>* targetActionHandlers;

@end

@implementation SYZRouterModuleManager
SYZSingletonImplementation(SYZRouterModuleManager)

- (void)registerModule:(Class)moduleClass {
    if (moduleClass == nil) return;
    SYZRouterBaseEntranceModule* moduleInstance = [moduleClass new];
    if ([moduleInstance isKindOfClass:[SYZRouterBaseEntranceModule class]]) {
        NSArray<NSString*> *names = moduleInstance.moduleNames;
        [moduleInstance modSetup:[SYZRouterContext sharedInstance]];
        for (NSString* name in names) {
            NSString* moduleName = [name lowercaseString];
            self.allDynamicModule[moduleName] = moduleInstance;
            //存起来
            NSMutableDictionary* moduleInfo = [NSMutableDictionary new];
            moduleInfo[SYZ_ROUTER_CLASS] = moduleClass;
            moduleInfo[SYZ_ROUTER_NAME] = moduleName;
            self.modulesInfo[moduleName] = moduleInfo;
        }
    }
}

- (void)unregisterModule:(SYZRouterBaseEntranceModule *)module {
    @synchronized(self.allDynamicModule) {
        [module modDealloc:[SYZRouterContext sharedInstance]];
        NSArray<NSString*>* names = module.moduleNames;
        for (NSString* name in names) {
            [self.allDynamicModule removeObjectForKey:[name lowercaseString]];
        }
    }
}

- (NSArray<SYZRouterBaseEntranceModule*>*)allModules {
    return self.allDynamicModule.allValues;
}

- (SYZRouterBaseEntranceModule *)moduleByName:(NSString *)name {
    name = [name lowercaseString];
    SYZRouterBaseEntranceModule *module = self.allDynamicModule[name];
    if (module == nil) {
        NSDictionary* moduleInfo = self.modulesInfo[name];
        [self registerModule:moduleInfo[SYZ_ROUTER_CLASS]];
        module = self.allDynamicModule[name];
    }
    return module;
}

- (SYZOneParamReturnCallback)handlerForTarget:(NSString*)aTarget action:(NSString*)aAction {
    if (SYZIsEmptyString(aTarget) || SYZIsEmptyString(aAction)) return nil;
    NSString* key = [self _keyForTarget:aTarget action:aAction];
    return self.targetActionHandlers[key];
}

/**
 额外注册 target-action，规则不变，target 和 action全部小写，如果target-action已存在，优先调用handler
 如： [SYZGlobalMediator registerTarget:@"aaa" action:@"bbb" handler:id(^)(id){}];
 */
- (void)registerTarget:(NSString*)aTarget action:(NSString*)aAction handler:(SYZOneParamReturnCallback)handler {
    if (SYZIsEmptyString(aTarget) || SYZIsEmptyString(aAction) || handler == nil) {
        return;
    }

    aTarget = [aTarget lowercaseString];
    aAction = [aAction lowercaseString];

    NSString* key = [self _keyForTarget:aTarget action:aAction];
    self.targetActionHandlers[key] = handler;
}

/** 注销所有相关target-action*/
- (void)unregisterTarget:(NSString*)aTarget {
    aTarget = [aTarget stringByAppendingString:@"/"];
    NSMutableArray* keys = [NSMutableArray new];
    NSDictionary<NSString*,SYZOneParamReturnCallback>* targetActionHandlersCopy = self.targetActionHandlers.copy;
    [targetActionHandlersCopy enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, SYZOneParamReturnCallback  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key rangeOfString:aTarget].location == 0) {
            [keys addObject:key];
        }
    }];
    if (SYZIsNotEmptyArray(keys)) {
        @synchronized(self.targetActionHandlers) {
            [self.targetActionHandlers removeObjectsForKeys:keys];
        }
    }
}

- (void)unregisterTarget:(NSString*)aTarget action:(NSString*)aAction {
    if (SYZIsEmptyString(aTarget) || SYZIsEmptyString(aAction)) return;
    NSString* key = [self _keyForTarget:aTarget action:aAction];
    @synchronized(self.targetActionHandlers) {
        [self.targetActionHandlers removeObjectForKey:key];
    }
}

- (NSString*)_keyForTarget:(NSString*)aTarget action:(NSString*)aAction {
    return [NSString stringWithFormat:@"%@/%@",[aTarget lowercaseString],[aAction lowercaseString]];
}

#pragma mark - Lazy
SYZLazyCreateMutableDictionary(modulesInfo)
SYZLazyCreateMutableDictionary(allDynamicModule)
SYZLazyCreateMutableDictionary(targetActionHandlers)
@end

//
//  SYZRouterContext.m
//  SYZMediator
//
//  Created by sundasheng1985 on 03/10/2019.
//

#import "SYZRouterContext.h"
#import <SYZMediator/SYZMediator.h>

/** 本地所有安装版本列表*/
static NSString* SYZ_ROUTER_CONTEXT_VERSION_LIST = @"SYZRouterContextVersionListKey";
/** 当前版本进入的次数，只分为1次等*/
static NSString* SYZ_ROUTER_CONTEXT_VERSION_TIMES_MAP = @"SYZRouterContextVersionTimesMapKey";

@implementation SYZRouterContext

+ (void)load {
    NSString* curVersion = [UIApplication syz_version];
    if (SYZIsEmpty(curVersion)) return;
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* versionLists = [[userDefaults arrayForKey:SYZ_ROUTER_CONTEXT_VERSION_LIST] mutableCopy];
    if (versionLists == nil) versionLists = [NSMutableArray new];
    if (versionLists.count == 0) {
        [versionLists addObject:curVersion];
    } else if ([versionLists.firstObject isEqualToString:curVersion] == NO) {
        [versionLists insertObject:curVersion atIndex:0];
    }

    NSMutableDictionary* versionTimesMap = [[userDefaults dictionaryForKey:SYZ_ROUTER_CONTEXT_VERSION_TIMES_MAP] mutableCopy];
    if (versionTimesMap == nil) versionTimesMap = [NSMutableDictionary new];
    NSNumber* times = [versionTimesMap[curVersion] syz_toNumber];
    if (times.unsignedCharValue < 3) {
        times = @([times unsignedCharValue] + 1);
    }
    versionTimesMap[curVersion] = times;
    [userDefaults setObject:versionTimesMap forKey:SYZ_ROUTER_CONTEXT_VERSION_TIMES_MAP];
    [userDefaults setObject:versionLists forKey:SYZ_ROUTER_CONTEXT_VERSION_LIST];
    [userDefaults synchronize];
}

+ (instancetype)sharedInstance {
    static SYZRouterContext * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    SYZRouterContext* context = [[[self class] allocWithZone:zone] init];
    context.application = self.application;
    context.launchOptions = self.launchOptions;
    return context;
}

- (BOOL)isTarget:(NSString*)target {
    return [self.target syz_isEqualToIgnoreCaseString:target.lowercaseString];
}

- (BOOL)isAction:(NSString*)action {
    return [self.action syz_isEqualToIgnoreCaseString:action];
}

/** 对参数进行添加，如果已存在，则覆盖*/
- (void)appendValue:(id<NSCopying>)value forKey:(id<NSCopying>)key {
    NSMutableDictionary* paramsM = [SYZNoNilDictionary(self.customParams) syz_toMutable];
    paramsM[key] = value;
    self.customParams = paramsM;
}

- (nullable id)objectForKey:(id<NSCopying>)aKey {
    return self.customParams[aKey];
}

- (void)setObject:(id<NSCopying>)object forKey:(id<NSCopying>)key {
    [self appendValue:object forKey:key];
}

#pragma mark - Publics
/** 当前版本是否第一次进入*/
- (BOOL)currentVersionFirstOpen {
    return [self _openTimesForVersion:[UIApplication syz_version]] == 1;
}

/** 是否是从低版本升级来的，否则就是直接安装的*/
- (BOOL)isUpdateFromLowVersion {
    return self.appVersionList.count > 1;
}

/** 是从哪个低版本升级来的，如果直接安装，则为nil*/
- (BOOL)isUpdateFromLowVersion:(NSString**)lastVersion {
    BOOL ret = NO;
    *lastVersion = nil;
    if ([self isUpdateFromLowVersion]) {
        ret = YES;
        *lastVersion = self.appVersionList[1];
    }
    return ret;
}

/** 判断某个版本是否打开过，只要有一次即代表打开过*/
- (BOOL)checkVersionIsOpened:(NSString*)version {
    return [self _openTimesForVersion:version] > 0;
}

/** 是否是从某个版本升级的*/
- (BOOL)isUpdateFromVersion:(NSString*)lowVersion {
    return [[self appVersionList] containsObject:[lowVersion syz_toString]];
}

/** 当前手机安装过的版本列表*/
- (NSArray<NSString*>*)appVersionList {
    return [[NSUserDefaults standardUserDefaults] arrayForKey:SYZ_ROUTER_CONTEXT_VERSION_LIST];
}

/** 某个版本打开次数*/
- (unsigned char)_openTimesForVersion:(NSString*)version {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* versionTimesMap = [userDefaults dictionaryForKey:SYZ_ROUTER_CONTEXT_VERSION_TIMES_MAP];
    return [versionTimesMap[version] unsignedCharValue];
}

/** context会重新交给mediator进行处理*/
- (void)redo {
    [[SYZMediator sharedMediator] routeContext:self];
}

/** 是否需要构建条件*/
- (BOOL)requireBuildCondition {
    return _conditionBuilder == nil;
}

/** 获取所有的condition*/
- (NSArray*)conditions {
    if (_conditionBuilder == nil) return @[];
    return self.conditionBuilder.build();
}

- (SYZRouterConditionBuilder *)conditionBuilder {
    if (_conditionBuilder == nil) {
        _conditionBuilder = [[SYZRouterConditionBuilder alloc] init];
    }
    return _conditionBuilder;
}

@end

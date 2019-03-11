//
//  SYZRouterContext.h
//  SYZMediator
//
//  Created by sundasheng1985 on 03/10/2019.
//

#import <Foundation/Foundation.h>
#import <SYZUIBasekit/SYZUIBasekit.h>
#import "SYZRouterConditionBuilder.h"

/** 上下文，系统的配置，应用的配置等*/
@interface SYZRouterContext : NSObject<NSCopying>
+ (instancetype)sharedInstance;
/** 当前application*/
@property (nonatomic,strong) UIApplication* application;
/** 启动参数*/
@property (nonatomic,strong) NSDictionary* launchOptions;
/** 对访问权限等进行控制*/
@property (nonatomic,strong) SYZRouterConditionBuilder* conditionBuilder;

/** 当前版本是否第一次进入*/
- (BOOL)currentVersionFirstOpen;
/** 是否是从低版本升级来的，否则就是直接安装的*/
- (BOOL)isUpdateFromLowVersion;
/** 是从哪个低版本升级来的，如果直接安装，则为nil*/
- (BOOL)isUpdateFromLowVersion:(NSString**)lastVersion;
/** 判断某个版本是否打开过，只要有一次即代表打开过*/
- (BOOL)checkVersionIsOpened:(NSString*)version;
/** 当前手机安装过的版本列表*/
- (NSArray<NSString*>*)appVersionList;
/** 是否是从某个版本升级的*/
- (BOOL)isUpdateFromVersion:(NSString*)lowVersion;

/** 以下为自定义参数，每个路由都不一样*/
@property (nonatomic,strong) NSDictionary* customParams;
@property (nonatomic,strong) NSString* target;
@property (nonatomic,strong) NSString* action;
/** 忽略大小写进行比较*/
- (BOOL)isTarget:(NSString*)target;
- (BOOL)isAction:(NSString*)action;

/** 对参数进行添加，如果已存在，则覆盖*/
- (void)appendValue:(id<NSCopying>)value forKey:(id<NSCopying>)key;

- (nullable id)objectForKey:(id<NSCopying>)aKey;
- (void)setObject:(id<NSCopying>)object forKey:(id<NSCopying>)key;

/** 如果是controller会自定进行路由*/
@property (nonatomic,assign) BOOL autoRoute;
/** context会重新交给mediator进行处理*/
- (void)redo;

/** 是否需要构建条件*/
- (BOOL)requireBuildCondition;

/** 获取所有的condition*/
- (NSArray*)conditions;

@end

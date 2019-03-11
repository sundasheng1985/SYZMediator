//
//  SYZRouterPackage.h
//  SYZMediator
//
//  Created by sundasheng1985 on 03/10/2019.
//

#import <Foundation/Foundation.h>
#import <SYZUIBasekit/SYZUIBasekit.h>

/** 对参数等进行封装，便于传递非普通参数类型*/
@interface SYZRouterPackage : NSObject

+ (instancetype)poackageWithTarget:(NSString*)target action:(NSString*)action params:(NSDictionary*)params;

/** 目标模块*/
@property (nonatomic,copy) NSString* target;
/** 对应处理方法*/
@property (nonatomic,copy) NSString* action;
/** 参数*/
@property (nonatomic,strong) NSDictionary* params;

/** 对参数进行添加，如果已存在，则覆盖*/
- (void)appendValue:(id<NSCopying>)value forKey:(id<NSCopying>)key;

@end

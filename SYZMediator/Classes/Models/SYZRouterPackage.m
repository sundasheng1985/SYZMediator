//
//  SYZRouterPackage.m
//  SYZMediator
//
//  Created by sundasheng1985 on 03/10/2019.
//

#import "SYZRouterPackage.h"

@implementation SYZRouterPackage

+ (instancetype)poackageWithTarget:(NSString*)target action:(NSString*)action params:(NSDictionary*)params {
    SYZRouterPackage* package = [SYZRouterPackage new];
    package.target = target;
    package.action = action;
    package.params = params;
    return package;
}

/** 对参数进行添加，如果已存在，则覆盖*/
- (void)appendValue:(id<NSCopying>)value forKey:(id<NSCopying>)key {
    NSMutableDictionary* paramsM = [SYZNoNilDictionary(self.params) syz_toMutable];
    [paramsM syz_appendingKey:(id)key value:value];
    self.params = paramsM;
}

@end

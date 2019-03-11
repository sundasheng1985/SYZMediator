//
//  SYZRouterConditionBuilder.m
//  SYZMediator
//
//  Created by sundasheng1985 on 03/10/2019.
//

#import "SYZRouterConditionBuilder.h"
#import <SYZUIBasekit/SYZUIBasekit.h>

@interface SYZRouterConditionBuilder ()
@property (nonatomic,strong) NSMutableArray* conditions;
@end

@implementation SYZRouterConditionBuilder

#pragma mark - Public
/** 添加一个权限*/
- (SYZRouterConditionBuilder*(^)(NSString* condition))addCondition {
    return ^SYZRouterConditionBuilder*(NSString* condition) {
        if (SYZIsNotEmptyString(condition)) {
            [self.conditions addObject:condition];
        }
        return self;
    };
}

/** 添加一组权限*/
- (SYZRouterConditionBuilder*(^)(NSArray<NSString*>* conditions))addConditions {
    return ^SYZRouterConditionBuilder*(NSArray<NSString*>* conditions) {
        if (SYZIsNotEmptyArray(conditions)) {
            [self.conditions addObjectsFromArray:conditions];
        }
        return self;
    };
}

- (NSArray<NSString *> * _Nonnull (^)(void))build {
    return ^NSArray<NSString*>*() {
        return self.conditions.copy;
    };
}

#pragma mark - Lazy
SYZLazyCreateMutableArray(conditions)

@end

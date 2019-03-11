//
//  SYZRouterConditionBuilder.h
//  SYZMediator
//
//  Created by sundasheng1985 on 03/10/2019.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYZRouterConditionBuilder : NSObject

/** 添加一个权限*/
- (SYZRouterConditionBuilder*(^)(NSString* aCondition))addCondition;

/** 添加一组权限*/
- (SYZRouterConditionBuilder*(^)(NSArray<NSString*>* conditions))addConditions;

- (NSArray<NSString*>*(^)(void))build;

@end

NS_ASSUME_NONNULL_END

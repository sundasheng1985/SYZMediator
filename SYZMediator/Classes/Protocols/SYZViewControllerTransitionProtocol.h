//
//  SYZViewControllerTransitionProtocol.h
//  SYZMediator
//
//  Created by sundasheng1985 on 03/10/2019.
//  Copyright (c) 2019 sundasheng1985. All rights reserved.
//

#ifndef SYZViewControllerTransitionProtocol_h
#define SYZViewControllerTransitionProtocol_h
@class SYZRouterContext;
typedef NS_ENUM(NSUInteger,SYZPageTransitionType) {
    SYZPageTransitionTypePush = 0,
    SYZPageTransitionTypePresent
};

@protocol SYZViewControllerTransitionProtocol<NSObject>
/** 转场方式，如果不实现，默认是push*/
- (SYZPageTransitionType)transitionTypeForContext:(SYZRouterContext*)context;
@end

#endif /* SYZViewControllerTransitionProtocol_h */

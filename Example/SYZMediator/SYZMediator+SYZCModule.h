//
//  SYZMediator+SYZCModule.h
//  SYZMediator_Example
//
//  Created by sun on 2019/3/14.
//  Copyright © 2019年 sundasheng1985. All rights reserved.
//

#import <SYZMediator/SYZMediator.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const KSYZMediatorC_target;
extern NSString * const KSYZMediatorC_main;

@interface SYZMediator (SYZCModule)

- (void)main_open;
@end

NS_ASSUME_NONNULL_END

//
//  SYZMediatorMacros.h
//  SYZMediator
//
//  Created by sundasheng1985 on 03/10/2019.
//

#ifndef SYZMediatorMacros_h
#define SYZMediatorMacros_h

/** 注册单个host*/
#define SYZ_Export_Module(module) \
    + (void)load { [SYZMediator registerModule:self]; } \
    - (NSArray<NSString*>*)moduleNames { return @[@#module]; }

/** 注册至多个host*/
#define SYZ_Export_Modules() \
+ (void)load { [SYZMediator registerModule:self]; }


#define SYZ_Router_Define_Action(actionName) \
    - (id)Action_##actionName:(SYZRouterContext*)context;

#endif /* SYZMediatorMacros_h */

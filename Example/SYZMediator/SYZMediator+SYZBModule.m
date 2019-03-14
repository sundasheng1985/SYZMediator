//
//  SYZMediator+SYZBModule.m
//  SYZMediator_Example
//
//  Created by sun on 2019/3/14.
//  Copyright © 2019年 sundasheng1985. All rights reserved.
//

#import "SYZMediator+SYZBModule.h"

static NSString* B_moduleName = @"b";

@implementation SYZMediator (SYZBModule)


- (SYZRouterPackage*)b_detailPackage:(NSString*)someId callback:(SYZCallback)callback{
    SYZRouterPackage* package = [SYZRouterPackage new];
    package.target = B_moduleName;
    package.action = @"detail";
    package.params = NSDictionaryOfVariableBindings(someId,callback);
    return package;
}

- (UIViewController*)b_detailPage:(NSString*)someId callback:(SYZCallback)callback{
     return [self performTarget:B_moduleName action:@"detail" params:NSDictionaryOfVariableBindings(someId,callback)];
}

- (NSString*)b_detailLink:(NSString*)someId{
    return [self makeShortLink:B_moduleName action:@"detail" params:NSDictionaryOfVariableBindings(someId)];
}

@end

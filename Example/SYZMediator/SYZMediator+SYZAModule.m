//
//  SYZMediator+SYZAModule.m
//  SYZMediator_Example
//
//  Created by sun on 2019/3/14.
//  Copyright © 2019年 sundasheng1985. All rights reserved.
//

#import "SYZMediator+SYZAModule.h"

@implementation SYZMediator (SYZAModule)

/** target 的a 是个标识 */
- (UIViewController *)a_detailPageWithId:(NSString *)aId {
    NSMutableDictionary* params = [NSMutableDictionary new];
    params[@"id"] = aId;
    return [self performTarget:@"a" action:@"detail" params:params];
}
@end

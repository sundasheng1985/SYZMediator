//
//  SYZMediator+SYZBModule.h
//  SYZMediator_Example
//
//  Created by sun on 2019/3/14.
//  Copyright © 2019年 sundasheng1985. All rights reserved.
//

#import <SYZMediator/SYZMediator.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SYZCallback)(NSString* word);
@interface SYZMediator (SYZBModule)

- (SYZRouterPackage*)b_detailPackage:(NSString*)someId callback:(SYZCallback)callback;

- (UIViewController*)b_detailPage:(NSString*)someId callback:(SYZCallback)callback;

- (NSString*)b_detailLink:(NSString*)someId;

@end

NS_ASSUME_NONNULL_END

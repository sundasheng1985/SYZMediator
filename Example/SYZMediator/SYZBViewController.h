//
//  SYZBViewController.h
//  SYZMediator_Example
//
//  Created by sun on 2019/3/14.
//  Copyright © 2019年 sundasheng1985. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SYZMediator/SYZMediator.h>
#import "SYZMediator+SYZBModule.h"
NS_ASSUME_NONNULL_BEGIN

@interface SYZBViewController : UIViewController<SYZViewControllerTransitionProtocol>

- (instancetype)initWithId:(NSString*)someId callback:(SYZCallback)callback;
@end

NS_ASSUME_NONNULL_END

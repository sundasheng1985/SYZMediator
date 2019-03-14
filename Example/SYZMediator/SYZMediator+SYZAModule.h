//
//  SYZMediator+SYZAModule.h
//  SYZMediator_Example
//
//  Created by sun on 2019/3/14.
//  Copyright © 2019年 sundasheng1985. All rights reserved.
//

#import <SYZMediator/SYZMediator.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYZMediator (SYZAModule)

- (UIViewController*)a_detailPageWithId:(NSString*)aId;
@end

NS_ASSUME_NONNULL_END

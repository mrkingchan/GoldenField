//
//  AppDelegate+Configuration.h
//  GoldenField
//
//  Created by Macx on 2018/5/11.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Configuration)


/**
 配置一些三方

 @param complete 配置之后的回调 
 */
- (void)confurationWithComplete:(void (^)(void))complete;

@end

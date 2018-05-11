//
//  AppDelegate+Configuration.m
//  GoldenField
//
//  Created by Macx on 2018/5/11.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "AppDelegate+Configuration.h"

@implementation AppDelegate (Configuration)

- (void)confurationWithComplete:(void (^)(void))complete {
    //xxx配置某些三方之内的代码
    [self registerAppWithComplete:complete];
}

- (void)registerAppWithComplete:(void (^)(void))complete {
    [NetTool innerPostWithUrl:@"register"
                       params:@{}
                       target:nil
                       sucess:^(id responseData) {
                           
                       } failure:^(NSString *errorStr) {
                           
                       }];
}
@end

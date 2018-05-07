//
//  BaseVC.m
//  GoldenField
//
//  Created by Macx on 2018/5/7.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)verifyLogin:(void (^)(void))complete {
    if ([DataManager shareInstance].model.isLogin) {
        if (complete) {
            complete();
        }
    } else {
        //跳转登录
    }
}


@end

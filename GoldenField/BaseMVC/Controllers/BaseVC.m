//
//  BaseVC.m
//  GoldenField
//
//  Created by Macx on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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

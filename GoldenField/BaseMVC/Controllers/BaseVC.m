//
//  BaseVC.m
//  GoldenField
//
//  Created by Macx on 2018/5/7.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "BaseVC.h"
#import "LoginVC.h"
#import "MainVC.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tasks = [NSMutableArray new];
}

- (void)verifyLogin:(void (^)(void))complete {
    if (kAppUser.isLogin) {
        if (complete) {
            complete();
        }
    } else {
        //跳转登录
        MainVC  *rootVC = (MainVC *) [UIApplication sharedApplication].keyWindow.rootViewController;
        SuperNaviVC *naviController = rootVC.selectedViewController;
        UIViewController *currentVC = naviController.viewControllers.lastObject;
        LoginVC *loginVC = [[LoginVC alloc] initWithLoginCompleteBlock:complete];
        SuperNaviVC *loginNavi = [[SuperNaviVC alloc] initWithRootViewController:loginVC];
        [currentVC presentViewController:loginNavi animated:YES completion:nil];
    }
}

-(void)addNet:(NSURLSessionDataTask *)task {
    [self.tasks addObject:task];
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.tasks.count) {
        [self.tasks  enumerateObjectsUsingBlock:^(NSURLSessionDataTask *task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
    }
}

-(void)dealloc {
    //释放网络操作
    [self.tasks enumerateObjectsUsingBlock:^(NSURLSessionDataTask *task, NSUInteger idx, BOOL * _Nonnull stop) {
        [task cancel];
    }];
    self.tasks = nil;
}
@end

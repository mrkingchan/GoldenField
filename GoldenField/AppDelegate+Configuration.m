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
    
    //分享
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession
                                          appKey:kUmengAppKey
                                       appSecret:kUmengAppSecretKey
                                     redirectURL:@""];
    
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

- (UIViewController *)alertViewControllerWithTitle:(NSString *)titleStr
                               class:(_Nonnull Class)className
                         normalImage:(UIImage *)normalImage
                       selectedImage:(UIImage *)selectedImage {
    UIViewController *viewController = [className new];
    if (kiOSVersion >=7.0) {
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:titleStr
                                                           image:normalImage
                                                   selectedImage:selectedImage];
        viewController.tabBarItem = item;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
[viewController.tabBarItem  setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:normalImage];
#pragma clang diagnostic pop
    }
    return viewController;
}

@end

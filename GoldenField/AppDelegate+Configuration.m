//
//  AppDelegate+Configuration.m
//  GoldenField
//
//  Created by Chan on 2018/5/11.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "AppDelegate+Configuration.h"

@implementation AppDelegate (Configuration)

- (void)configurationWithComplete:(void (^)(void))complete {
    //xxx配置某些三方之内的代码
    
    [[UMSocialManager defaultManager] setUmSocialAppkey:kUmengAppKey];
    //开启日志
    [[UMSocialManager defaultManager] openLog:YES];
    //微信聊天分享
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession
                                          appKey:kWeChatAppKey
                                       appSecret:kWechatAppSecretKey
                                     redirectURL:kBaseURL];
    //微信朋友圈分享
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine
                                          appKey:kWeChatAppKey
                                       appSecret:kWechatAppSecretKey
                                     redirectURL:kBaseURL];
}

#pragma mark  -- registerApp Method
- (void)registerAppWithComplete:(void (^)(void))complete {
    [NetTool innerPostWithUrl:@"register"
                       params:@{}
                       target:nil
                       sucess:^(id responseData) {
                           
                       } failure:^(NSString *errorStr) {
                           
                       }];
}

- (UIViewController *)buildViewControllerWithTitle:(NSString *)titleStr
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

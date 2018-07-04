//
//  AppDelegate+Configuration.m
//  GoldenField
//
//  Created by Chan on 2018/5/11.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "AppDelegate+Configuration.h"
#import <WXApi.h>
@implementation AppDelegate (Configuration)

////配置信息
- (void)configurationWithComplete:(void (^)(void))complete {
    //xxx配置某些三方之内的代码
    /*[[UMSocialManager defaultManager] setUmSocialAppkey:kUmengAppKey];
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
    
    //收藏
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatFavorite
                                          appKey:kWeChatAppKey
                                       appSecret:kWechatAppSecretKey
                                     redirectURL:kBaseURL];
    
    /*
    //分享的代码
    UMShareImageObject *image = [UMShareImageObject shareObjectWithTitle:@"xxx"
                                                                   descr:@"xxx"
                                                               thumImage:nil];
    UMSocialMessageObject *shareMessage = [UMSocialMessageObject messageObjectWithMediaObject:image];
    shareMessage.text = @"xxx";
    shareMessage.title = @"xxx";
    shareMessage.moreInfo = @{@"ext":@"ext"};
    
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession
                                        messageObject:shareMessage
                                currentViewController:[UIApplication sharedApplication].keyWindow.rootViewController
                                           completion:^(id result, NSError *error) {
                                              //分享成功or失败回调
                                               if (error) {
                                                   if (DEBUG) {
                                                       NSLog(@"shareError = %@",error.localizedDescription);
                                                   }
                                               }else {
                                                   //分享response
                                                   if ([result isKindOfClass:[UMSocialShareResponse class]]) {
                                                       UMSocialShareResponse *response = (UMSocialShareResponse *)result;
                                                       if (DEBUG) {
                                                           NSLog(@"分享结果:%@",response.message);
                                                       }
                                                   }
                                               }
                                           }];*/
    
    [self registerAppWithComplete:complete];
}

//回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.host rangeOfString:@"safePay"].location != NSNotFound) {
        //支付宝支付
        //跳转至支付宝代码。。。
        return YES;
    } else if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tecent.xin"] && [url.absoluteString rangeOfString:@"pay"].length) {
        //微信支付 url里面会出现pay而分享里面不会有pay 区分就在这里
        //跳转微信支付代码
        return  YES;
    } else {
        //友盟分享 跳转微信去分享
//        return [[UMSocialManager defaultManager] handleOpenURL:url options:options];
        return [WXApi handleOpenURL:url delegate:self];
    }
}

///depreccated Method
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([url.absoluteString rangeOfString:@"com.tecent.xin"].location != NSNotFound) {
        return YES;
    }else {
//        return [[UMSocialManager defaultManager] handleOpenURL:url];
        return [WXApi handleOpenURL:url delegate:self];
    }
}

// MARK:  -- registerApp Method
- (void)registerAppWithComplete:(void (^)(void))complete {
    [NetTool innerPostWithUrl:@"register"
                       params:@{}
                       target:nil
                       sucess:^(id responseData) {
                           
                       } failure:^(NSString *errorStr) {
                           
                       }];
}


/**
 构建指定class的viewConttroller

 @param titleStr title
 @param className className
 @param normalImage normalImage
 @param selectedImage selectedImage
 @return class->UIViewController
 */
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

// MARK: - build viewController by given a specified className,titleStr,normalImage.selectedImage return a UIViewController object,which is configured by given paramters
- (UIViewController *)buildViewControllerWithClass:(Class)className
                                             title:(NSString *)titleStr
                                       normalImage:(UIImage *)normalImage
                                     selectedImage:(UIImage *)selectedImage {
    if ([className isSubclassOfClass:[UIViewController class]]) {
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
    } else {
        return nil;
    }
}

-(void)reloadInputViews {
    if (_cmd) {
        NSString *cmdStr = NSStringFromSelector(_cmd);
        if ([cmdStr rangeOfString:@"location"].length) {
            NSArray *items = [cmdStr componentsSeparatedByString:@"."];
            for (NSString *subStr in items) {

            }
        }
    }
}
@end

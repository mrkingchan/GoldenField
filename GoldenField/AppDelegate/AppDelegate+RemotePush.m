//
//  AppDelegate+RemotePush.m
//  YQ
//
//  Created by Macx on 2018/7/11.
//  Copyright © 2018年 annkey. All rights reserved.
//

#import "AppDelegate+RemotePush.h"

@implementation AppDelegate (RemotePush)

- (void)JPushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupWithOption:launchOptions appKey:@"c8df2af053b339253b69c33e" channel:nil isProduction:YES adertisingIdentifier:nil];
    //开启Crash日志收集
    [JPUSHService crashLogON];
    //监听极光事件处理
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkDidRegister:) name:kJPFNetworkDidRegisterNotification object:nil];
}

#pragma mark --initialize JpushSDK
- (void)setupWithOption:(NSDictionary *)options
                 appKey:(NSString *)appKey
                channel:(NSString *)channel
           isProduction:(BOOL)isProduction
   adertisingIdentifier:(NSString *)advertisiId {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
#endif
    }
#else
    [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                      UIRemoteNotificationTypeSound |
                                                      UIRemoteNotificationTypeAlert)
                                          categories:nil];
#endif
    [JPUSHService setupWithOption:options appKey:appKey channel:channel apsForProduction:isProduction advertisingIdentifier:advertisiId];
}


#pragma mark --JPushRegister
- (void)netWorkDidRegister:(NSNotification *)noti {
    NSLog(@"极光推送注册成功！");
}

#pragma mark --JPushLogin
- (void)networkDidLogin:(NSNotification *)noti {
    NSLog(@"极光推送登录成功!");
    if ([JPUSHService registrationID]) {
    }
}

#pragma mark --customMessage
- (void)networkDidReceiveMessage:(NSNotification *)noti {
}

#pragma mark -----register Token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

#pragma mark --recieve Notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
}

#pragma mark --handleRemoteNotification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark -----register Token failed
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
@end

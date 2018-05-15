//
//  AppDelegate.m
//  GoldenField
//
//  Created by Chan on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "AppDelegate.h"
#import "MainVC.h"
#import "GuideHelpView.h"

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /*_window = [UIWindow new];
    _window.frame = [UIScreen mainScreen].bounds;
    _window.backgroundColor = [UIColor whiteColor];
    _window.rootViewController = [MainVC new];
    [_window makeKeyAndVisible];*/
    _window = InsertWindow([MainVC new]);
    //新手引导页
    if (DEBUG) {
        NSLog(@"DebugMode");
    } else {
        NSLog(@"ReleaseMode");
    }
    [self buildShorcutItems];
    [self configureGuide];
    [self configureCommonPushWithLanunchOptions:launchOptions];
    return YES;
}

#pragma mark  -- 推送设置
- (void)configureCommonPushWithLanunchOptions:(NSDictionary*)launchOptions {
    //推送
    UMessageRegisterEntity *entity = [UMessageRegisterEntity new];
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    }
    
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        //授权
        if (granted) {
            
        } else {
            
        }
    }];
}

#pragma mark  -- 引导页
- (void)configureGuide {
    NSMutableArray *images = [NSMutableArray new];
    for (int i = 0; i < 3; i ++) {
        NSString *imageName = [NSString stringWithFormat:@"guide_%i",i +1];
        UIImage *image = kIMAGE(imageName);
        [images addObject:image];
    }
    if ([kUserDefaultValueForKey(@"guidePass") integerValue]!=1) {
        [GuideHelpView guidehelpViewWithImageArray:images complete:^{
            kUserDefaultSetValue(@"guidePass", @(1));
            kSynchronize;
        }];
    }
}

#pragma mark  -- 交互推送
- (void)configureInteractPushWithLaunchOptions:(NSDictionary *)launchOptions {
    UMessageRegisterEntity * entity = [UMessageRegisterEntity new];
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert|UMessageAuthorizationOptionSound;
    if (kiOSVersion>=8 && kiOSVersion<10) {
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"打开应用";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"忽略";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
        actionCategory1.identifier = @"category1";//这组动作的唯一标示
        [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
        entity.categories = categories;
    }
    //如果要在iOS10显示交互式的通知，必须注意实现以下代码
    if (kiOSVersion>=10) {
        UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
        UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
        
        //UNNotificationCategoryOptionNone
        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
        UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category1" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        NSSet *categories = [NSSet setWithObjects:category1_ios10, nil];
        entity.categories=categories;
    }
    [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
    }];
}

#pragma mark  -- touchPress
-(void)buildShorcutItems {
    NSMutableArray *items = [NSMutableArray new];
    NSArray *types = @[@(UIApplicationShortcutIconTypeDate),
                       @(UIApplicationShortcutIconTypeHome),
                       @(UIApplicationShortcutIconTypeTask),
                       @(UIApplicationShortcutIconTypeLocation),
                       @(UIApplicationShortcutIconTypeLove)];
    for (int i = 0 ; i < 5; i ++) {
        UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:[types[i] integerValue]];
        UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:@"" localizedTitle:[NSString stringWithFormat:@"title%i",i  + 1] localizedSubtitle:[NSString stringWithFormat:@"subTitle%i",i + 1] icon:icon userInfo:@{@"item":@(i)}];
        [items addObject:item];
    }
    [UIApplication sharedApplication].shortcutItems = items;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
}

#pragma mark  -- UNUserNotificationCenterDelegate ios10 以上的推送接收方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于后台时的本地推送接受
    }
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    if (DEBUG) {
        NSLog(@"您点击的是%@",shortcutItem.localizedTitle);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

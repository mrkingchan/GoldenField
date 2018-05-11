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

@interface AppDelegate ()

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
    NSMutableArray *images = [NSMutableArray new];
    for (int i = 0; i < 3; i ++) {
        NSString *imageName = [NSString stringWithFormat:@"guide_%i",i +1];
        UIImage *image = kIMAGE(imageName);
        [images addObject:image];
    }
    if ([kUserDefaultValueForKey(@"guidePass") integerValue]!=1) {
        [GuideHelpView guidehelpViewWithImageArray:images complete:^{
            kUserDefaultSetValue(@"guidePass", @(0));
            kSynchronize;
        }];
    }
   [self buildShorcutItems];
    return YES;
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

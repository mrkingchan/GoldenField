//
//  MainVC.m
//  GoldenField
//
//  Created by Macx on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "MainVC.h"

@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *classNames = @[[HomeVC class],
                            [ProductVC class],
                            [DiscoveryVC class],
                            [MineVC class]];
    NSArray *titles =@[@"首页",@"产品",@"发现",@"我的"];
    NSMutableArray *subViewCnotrollers  = [NSMutableArray new];
    for (int i = 0; i < classNames.count; i ++) {
        NSString *normalImageName =  [NSString stringWithFormat:@"tabbar_%i",i  + 1];
        NSString *selectedImageName = [NSString stringWithFormat:@"tabbar_%i_s",i + 1];
        UIViewController *viewController = [self viewControllerWithClass:classNames[i]
                                                                   Title: titles[i]
                                                             normalImage:kIMAGE(normalImageName) selectedImage:kIMAGE(selectedImageName)];
        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:viewController];
        naviController.navigationItem.title = titles[i];
        [subViewCnotrollers addObject:naviController];
    }
    self.viewControllers = subViewCnotrollers;
    
    //底部tabbar
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:kFontSize(12)} forState:UIControlStateNormal];
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:kApperanceColor,NSFontAttributeName:kFontSize(12)} forState:UIControlStateSelected];
    
    //导航栏
    [[UINavigationBar appearance] setBarTintColor:kApperanceColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:kFontSize(16),NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

/**
  构建viewController
 
 @param className 所属类名
 @param titleStr titleStr
 @param normalImage tabbarItem的图片
 @param selectedImage tabbarItem的选中图片
 @return viewController
 */
- (UIViewController *)viewControllerWithClass:(Class)className
                                        Title:(NSString*)titleStr
                                  normalImage:(UIImage *)normalImage
                                selectedImage:(UIImage *)selectedImage {
    UIViewController *viewController = [className new];
    viewController.navigationItem.title = titleStr;
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:titleStr
                                                       image:[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:
                          [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    viewController.tabBarItem = item;
    viewController.title = titleStr;
    return viewController;
}

@end

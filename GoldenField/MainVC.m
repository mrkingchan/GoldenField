//
//  MainVC.m
//  GoldenField
//
//  Created by Chan on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "MainVC.h"

@interface MainVC ()

@end

@implementation MainVC

#pragma mark  -- lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    NSArray *classNames = @[[HomeVC class],
                            [ProductVC class],
                            [DiscoveryVC class],
                            [MineVC class]];
    NSArray *titles =@[@"首页",@"产品",@"发现",@"我的"];
    NSMutableArray *subViewControllers  = [NSMutableArray new];
    for (int i = 0; i < classNames.count; i ++) {
        NSString *normalImageName =  [NSString stringWithFormat:@"tabbar_%i",i  + 1];
        NSString *selectedImageName = [NSString stringWithFormat:@"tabbar_%i_s",i + 1];
        UIViewController *viewController = [self viewControllerWithClass:classNames[i]
                                                                   Title: titles[i]
                                                             normalImage:kIMAGE(normalImageName) selectedImage:kIMAGE(selectedImageName)];
        SuperNaviVC *naviController = [[SuperNaviVC alloc] initWithRootViewController:viewController];
        naviController.navigationItem.title = titles[i];
        [subViewControllers addObject:naviController];
    }
    self.viewControllers = subViewControllers;
    
    //底部tabbar
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:kFontSize(12)} forState:UIControlStateNormal];
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:kApperanceColor,NSFontAttributeName:kFontSize(12)} forState:UIControlStateSelected];
    
    //导航栏
    [[UINavigationBar appearance] setBarTintColor:kApperanceColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:kFontSize(16),NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

#pragma mark  -- private Method
/**
  构建viewController
 
 @param className 所属类名
 @param titleStr titleStr
 @param normalImage tabbarItem的图片
 @param selectedImage tabbarItem的选中图片
 @return viewController
 */
- (UIViewController *)viewControllerWithClass:(nonnull Class)className
                                        Title:(NSString*)titleStr
                                  normalImage:(UIImage *)normalImage
                                selectedImage:(UIImage *)selectedImage {
    UIViewController *viewController = [className new];
    viewController.navigationItem.title = titleStr;
    if (kiOSVersion >=7.0) {
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:titleStr
                                                           image:[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:
                              [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        viewController.tabBarItem = item;
        
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [viewController.tabBarItem setFinishedSelectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
#pragma clang diagnostic pop
    }
    viewController.title = titleStr;
    return viewController;
}
@end

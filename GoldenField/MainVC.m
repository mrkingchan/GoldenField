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

static MainVC *shareInstance = nil;

@implementation MainVC

// MARK: - shareInstance
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[MainVC alloc] init];
    });
    return shareInstance;
}

// MARK:  -- lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
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
        id extractedExpr = titles[i];
        naviController.navigationItem.title = extractedExpr;
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

// MARK: - 摇晃事件
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        //摇一摇
        [self.view.layer shake];
    }
}

// MARK: - 陀螺仪事件
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self InsertAlerController:@"别摇啦，脑子进水啦!别摇啦，脑子进水啦!别摇啦，脑子进水啦!别摇啦，脑子进水啦!别摇啦，脑子进水啦!别摇啦，脑子进水啦!别摇啦，脑子进水啦!" messageStr:@"" alertStyle:UIAlertControllerStyleAlert button1Title:@"确定" button1Action:^(NSString * title1 ) {
            
        } button2Title:nil
                     button2Action:^(NSString * title2) {
                         
                     } targetController:[UIApplication sharedApplication].keyWindow.rootViewController
         
         ];
#pragma clang diagnostic pop
    } else if (motion == UIEventSubtypeRemoteControlPlay) {
        //线控
    }
}

// MARK:  -- private Method
/**
  构建viewController
 
 @param className 所属类名
 @param titleStr titleStr
 @param normalImage tabbarItem的图片
 @param selectedImage tabbarItem的选中图片
 @return viewController
 */
- (UIViewController * _Nonnull )viewControllerWithClass:(nonnull Class)className
                                        Title:(NSString* )titleStr
                                  normalImage:(UIImage *)normalImage
                                selectedImage:(UIImage *)selectedImage {
    puts(__func__);
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

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item  {
    NSInteger index = [self.tabBar.items  indexOfObject:item];
    [self animationActionWithIndex:index];
}

// MARK:  -- animation Method
- (void)animationActionWithIndex:(NSUInteger)index {
    NSMutableArray *tempArray = [NSMutableArray new];
    for (UIView *subView in self.tabBar.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tempArray addObject:subView];
        }
    }
    //这里的排序是为了针对StoryBoard里面的无序处理，在StoryBoard里面会出现item是无序的情况,阿西吧嘞
    tempArray = [NSMutableArray arrayWithArray:[tempArray sortedArrayUsingComparator:^NSComparisonResult(UIView *subView1, UIView *subView2) {
        CGFloat X1 = subView1.frame.origin.x;
        CGFloat X2 = subView2.frame.origin.x;
        return [[NSNumber numberWithFloat:X1]  compare:[NSNumber numberWithFloat:X2]];
    }]];
    
    //放大
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.duration = 0.1;
    scaleAnimation.repeatCount= 1;
    scaleAnimation.autoreverses= YES;
    scaleAnimation.fromValue= [NSNumber numberWithFloat:0.7];
    scaleAnimation.toValue= [NSNumber numberWithFloat:1.3];
    
    //旋转
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @(0);
    rotationAnimation.toValue = @(2 * M_PI);
    rotationAnimation.duration = 0.1;
    rotationAnimation.repeatCount = 1;
    rotationAnimation.removedOnCompletion = YES;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    //动画组
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[scaleAnimation,rotationAnimation];
    group.duration = 0.1;
    group.repeatCount = 1;
    group.removedOnCompletion = YES;
    group.autoreverses = YES;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    UIView *itemView = (UIView *)tempArray[index];
    [itemView.layer addAnimation:scaleAnimation forKey:nil];
}

// MARK: - memory management
-(void)dealloc {
    
}

// MARK: - fixMemoryHotIssuesAction
- (void)fixHotMemoryIssueAction {
}
@end

//
//  BaseVC.m
//  GoldenField
//
//  Created by Chan on 2018/5/7.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "BaseVC.h"
#import "LoginVC.h"
#import "MainVC.h"

@interface BaseVC () <LoadingAndRefreshViewDelegate> {
    LoadingAndRefreshView   *_loadingAndRefreshView;
}

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tasks = [NSMutableArray new];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    if (@available(iOS 11.0, *)) {
        self.additionalSafeAreaInsets = UIEdgeInsetsMake(0, 0, iPhoneX_BOTTOM_HEIGHT, 0);
    }
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [self networkError];
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark  -- 交给子类去重写     
- (void)networkError {
    puts(__func__);
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

- (void)releaseNetWork {
    if (self.tasks.count) {
        [self.tasks enumerateObjectsUsingBlock:^(NSURLSessionDataTask *task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
    }
}

//添加网络操作队列
-(void)addNet:(NSURLSessionDataTask *)task {
    [self.tasks addObject:task];
}

#pragma mark  -- 在viewWillDisAppear和dealloc的时候 要释放网络操作
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.tasks.count) {
        //释放网络操作队列
        [self.tasks  enumerateObjectsUsingBlock:^(NSURLSessionDataTask *task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
    }
}

#pragma mark  -- memerory management
-(void)dealloc {
    //释放网络操作
    [self.tasks enumerateObjectsUsingBlock:^(NSURLSessionDataTask *task, NSUInteger idx, BOOL * _Nonnull stop) {
        [task cancel];
    }];
    self.tasks = nil;
}

#pragma mark  -- loadingView

- (void)addLoadingViewWithOffset:(CGFloat)offset {
    if (!_loadingAndRefreshView) {
        _loadingAndRefreshView = [[LoadingAndRefreshView alloc] initWithFrame:CGRectMake(0, offset, kScreenWidth, self.view.height - offset)];
        _loadingAndRefreshView.delegate = self;
    }
    if (!_loadingAndRefreshView.superview) {
        [self.view addSubview:_loadingAndRefreshView];
    }
    [self.view bringSubviewToFront:_loadingAndRefreshView];
}

#pragma mark - 加载成功
- (UIView *)loadingSuccess {
    if (_loadingAndRefreshView.superview) {
        [_loadingAndRefreshView removeFromSuperview];
    }
    return _loadingAndRefreshView;
}

#pragma mark - 加载中view
- (UIView *)loadingStart {
    return [self loadingStartWithOffset:0];
}

- (UIView *)loadingStartWithOffset:(CGFloat)offset {
    return [self loadingStartWithOffset:offset style:LoadingStyleNormal];
}

- (UIView *)loadingStartBgClear {
    return [self loadingStartBgClearWithOffset:0];
}

- (UIView *)loadingStartBgClearWithOffset:(CGFloat)offset {
    return [self loadingStartWithOffset:offset style:LoadingStyleBgClear];
}

- (UIView *)loadingStartWithOffset:(CGFloat)offset style:(LoadingStyle)style {
    [self addLoadingViewWithOffset:offset];
    [_loadingAndRefreshView setLoadingStateWithOffset:offset style:style];
    return _loadingAndRefreshView;
}

#pragma mark - 未偏移量的加载失败view
- (UIView *)loadingFail {
    [self loadingFailWithTitle:@"" imageStr:@""];
    return _loadingAndRefreshView;
}

- (UIView *)loadingFailWithTitle:(NSString *)title {
    [self loadingFailWithTitle:title imageStr:@""];
    return _loadingAndRefreshView;
}

- (UIView *)loadingFailWithTitle:(NSString *)title imageStr:(NSString *)imageStr {
    [self addLoadingViewWithOffset:0];
    [_loadingAndRefreshView setFailStateWithTitle:title imageStr:imageStr offset:0];
    return _loadingAndRefreshView;
}

#pragma mark - 带偏移量的加载失败view
- (UIView *)loadingFailWithOffset:(CGFloat)offset {
    [self loadingFailWithOffset:offset title:@"" imageStr:@""];
    return _loadingAndRefreshView;
}

- (UIView *)loadingFailWithOffset:(CGFloat)offset title:(NSString *)title {
    [self loadingFailWithOffset:offset title:title imageStr:@""];
    return _loadingAndRefreshView;
}

- (UIView *)loadingFailWithOffset:(CGFloat)offset title:(NSString *)title imageStr:(NSString *)imageStr {
    [self addLoadingViewWithOffset:offset];
    [_loadingAndRefreshView setFailStateWithTitle:title imageStr:imageStr offset:offset];
    _loadingAndRefreshView.loadingTip.hidden = NO;
    return _loadingAndRefreshView;
}

#pragma mark - 未带偏移量的无数据view
- (UIView *)loadingBlank {
    return [self loadingBlankWithTitle:@""];
}

- (UIView *)loadingBlankWithTitle:(NSString *)title {
    return [self loadingBlankWithTitle:title imageStr:@""];
}

- (UIView *)loadingBlankWithTitle:(NSString *)title imageStr:(NSString *)imageStr {
    return [self loadingBlankWithOffset:0 title:title imageStr:imageStr];
}

#pragma mark - 带偏移量的无数据view
- (UIView *)loadingBlankWithOffset:(CGFloat)offset {
    return [self loadingBlankWithOffset:offset title:@""];
}

- (UIView *)loadingBlankWithOffset:(CGFloat)offset title:(NSString *)title {
    return [self loadingBlankWithOffset:offset title:title imageStr:@""];
}

- (UIView *)loadingBlankWithOffset:(CGFloat)offset title:(NSString *)title imageStr:(NSString *)imageStr {
    return [self loadingBlankWithOffset:offset title:title imageStr:imageStr buttonTitle:@""];
}

- (UIView *)loadingBlankWithOffset:(CGFloat)offset title:(NSString *)title imageStr:(NSString *)imageStr buttonTitle:(NSString *)buttonTitle {
    [self addLoadingViewWithOffset:offset];
    [_loadingAndRefreshView setBlankStateWithTitle:title imageStr:imageStr buttonTitle:buttonTitle offset:offset];
    return _loadingAndRefreshView;
}

- (void)refreshClickWithStatus:(LoadingStatus)status {
    [self refreshClick];
}

#pragma mark  --交给子类去重写
- (void)refreshClick {
    puts(__func__);
}
@end

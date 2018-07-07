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
    _netWorkErrorView = InsertView(self.view, CGRectMake(0, -35, kScreenWidth, 35), kColorRed);
    InsertLabel(_netWorkErrorView, CGRectMake(0, 0, _netWorkErrorView.width, _netWorkErrorView.height), 1, @"网络未连接，请前往设置检查网络连接", kFontSize(13), kColorWhite, NO);
    self.tasks = [NSMutableArray new];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    if (@available(iOS 11.0, *)) {
        self.additionalSafeAreaInsets = UIEdgeInsetsMake(0, 0, iPhoneX_BOTTOM_HEIGHT, 0);
    }
    [[[NSThread alloc] initWithTarget:self selector:@selector(checkInterNetAction) object:nil] start];
    @weakify(self);
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        @strongify(self);
        [self netWorkChangWithNetWorkWithStatus:status];
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)checkInterNetAction {
    while (true) {
        /*@weakify(self);
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            @strongify(self);
            [self netWorkChangWithNetWorkWithStatus:status];
        }];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];*/
        [self netWorkChangWithNetWorkWithStatus:[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus];
    }
}
// MARK:  -- 交给子类去重写     

- (void)netWorkChangWithNetWorkWithStatus:(AFNetworkReachabilityStatus)status {
    
}

// MARK: - 登录验证
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

// MARK: - 释放网络操作队列
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

// MARK:  -- 在viewWillDisAppear和dealloc的时候 要释放网络操作
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.tasks.count) {
        //释放网络操作队列
        [self.tasks  enumerateObjectsUsingBlock:^(NSURLSessionDataTask *task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
    }
}

// MARK:  -- memerory management
-(void)dealloc {
    //释放网络操作
    [self.tasks enumerateObjectsUsingBlock:^(NSURLSessionDataTask *task, NSUInteger idx, BOOL * _Nonnull stop) {
        [task cancel];
    }];
    self.tasks = nil;
}

// MARK:  -- loadingView

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

// MARK: - 加载成功
- (UIView *)loadingSuccess {
    if (_loadingAndRefreshView.superview) {
        [_loadingAndRefreshView removeFromSuperview];
    }
    return _loadingAndRefreshView;
}

// MARK: - 加载中view
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

// MARK: - 未偏移量的加载失败view
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

// MARK: - 带偏移量的加载失败view
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

// MARK: - 未带偏移量的无数据view
- (UIView *)loadingBlank {
    return [self loadingBlankWithTitle:@""];
}

- (UIView *)loadingBlankWithTitle:(NSString *)title {
    return [self loadingBlankWithTitle:title imageStr:@""];
}

- (UIView *)loadingBlankWithTitle:(NSString *)title imageStr:(NSString *)imageStr {
    return [self loadingBlankWithOffset:0 title:title imageStr:imageStr];
}

// MARK: - 带偏移量的无数据view
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

// MARK:  --交给子类去重写
- (void)refreshClick {
    puts(__func__);
}

@end

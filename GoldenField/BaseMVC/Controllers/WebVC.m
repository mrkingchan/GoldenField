//
//  WebVC.m
//  GoldenField
//
//  Created by Chan on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "WebVC.h"
#import <WebKit/WebKit.h>

@interface WebVC () <WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate> {
    WKWebView *_webView;
    WKWebViewConfiguration *_configuration;
    UIProgressView *_progressView;
}

@end

@implementation WebVC

// MARK:  -- Setter Method
-(void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
    [_webView loadRequest:[NSURLRequest requestWithURL:kURL(urlStr)]];
}

// MARK:  -- initialize method
-(instancetype)initWithUrlString:(NSString *)urlStr {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _urlStr = urlStr;
    }
    return self;
}

// MARK:  -- lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
     _configuration = [WKWebViewConfiguration new];
    _configuration.userContentController = [WKUserContentController new];
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:_configuration];
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
    //进度条
    _progressView = InsertProgressView(self.view, CGRectMake(0, 2, kScreenWidth, 3.0), UIProgressViewStyleDefault, 0.0, kColorOrange, kColorWhite);
    
    ///下拉刷新
    @weakify(self);
    [_webView.scrollView  addLegendHeaderWithRefreshingBlock:^{
        @strongify(self);
        [self->_webView reload];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self->_webView.scrollView.header endRefreshing];
        });
    }];
    //KVO一定要记得移除 remove操作
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    //横扫返回
    _webView.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *leftSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipLeftAction:)];
    leftSwip.direction = UISwipeGestureRecognizerDirectionLeft;
    [_webView addGestureRecognizer:leftSwip];
    [NSThread detachNewThreadSelector:@selector(checkInterNet) toTarget:self withObject:nil];
}

//开线程检测网络连接状态
- (void)checkInterNet {
    while (true) {
        [self netWorkChangWithNetWorkWithStatus:[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus];
    }
}

//重写父类网络变化

-(void)netWorkChangWithNetWorkWithStatus:(AFNetworkReachabilityStatus)status {
    if (status == AFNetworkReachabilityStatusNotReachable) {
        self.netWorkErrorView.top = 0;
    } else {
        self.netWorkErrorView.top = -35;
    }
    _webView.top = self.netWorkErrorView.bottom;
    _webView.height = self.view.height - self.netWorkErrorView.bottom;
}

- (void)swipLeftAction:(UISwipeGestureRecognizer *)tap {
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
}

// MARK:  -- KVO 监测加载进度和标题 
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object  isEqual:_webView]) {
        if ([keyPath isEqualToString:@"title"]) {
            //title
            self.navigationItem.title = _webView.title;
        } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
            //进度
            double value = _webView.estimatedProgress;
            if (value<1.0) {
                [_progressView setProgress:value];
            } else {
                [UIView animateWithDuration:0.3 animations:^{
                    self->_progressView.alpha = 0.0;
                }];
            }
        }
    }
}

// MARK:  -- WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    [self loadingStartBgClear];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self loadingFail];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self loadingSuccess];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self loadingFail];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //加载策略
    decisionHandler(WKNavigationActionPolicyAllow);
}

// MARK:  -- WKScriptMessageHandler
- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    NSString *methodName = message.name;
    //根据methodName来吊起OC OC来进行响应的处理 像比如分享、相机相册吊起等等
    if ([methodName isEqualToString:@"share"]) {
        //三方分享
        NSDictionary *json = (NSDictionary *)[message.body mj_JSONObject];
    }
}

// MARK:  -- memerory management
- (void)dealloc{
    if (_webView) {
        //KVO一定要移除 否则会出现崩溃情况
        [_webView removeObserver:self forKeyPath:@"title"];
        [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
        _webView = nil;
    }
}

// MARK:  -- refreshClick
- (void)refreshClick {
    //重新加载webView
    [_webView loadRequest:[NSURLRequest requestWithURL:kURL(_urlStr)]];
}

@end

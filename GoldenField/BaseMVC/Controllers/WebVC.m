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
}

@end

@implementation WebVC

#pragma mark  -- Setter Method
-(void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
    [_webView loadRequest:[NSURLRequest requestWithURL:kURL(urlStr)]];
}

#pragma mark  -- initialize method
-(instancetype)initWithUrlString:(NSString *)urlStr {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _urlStr = urlStr;
    }
    return self;
}

#pragma mark  -- lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
     _configuration = [WKWebViewConfiguration new];
    _configuration.userContentController = [WKUserContentController new];
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:_configuration];
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
    
    @weakify(self);
    [_webView.scrollView  addLegendHeaderWithRefreshingBlock:^{
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self->_webView.scrollView.header endRefreshing];
        });
    }];
}

- (void)registerJSMethod {
    [_configuration.userContentController  addScriptMessageHandler:self name:@"xxxx"];
}


#pragma mark  -- memerory management
- (void)dealloc{
    if (_webView) {
        _webView = nil;
    }
}
@end

//
//  WebVC.m
//  GoldenField
//
//  Created by Macx on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "WebVC.h"
#import <WebKit/WebKit.h>

@interface WebVC () {
    NSString *_url;
    WKWebView *_webView;
}

@end

@implementation WebVC

-(instancetype)initWithUrlString:(NSString *)urlStr {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _url = urlStr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration *configure = [WKWebViewConfiguration new];
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configure];
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    
    @weakify(self);
    [_webView.scrollView  addLegendHeaderWithRefreshingBlock:^{
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self->_webView.scrollView.header endRefreshing];
        });
    }];
}

@end

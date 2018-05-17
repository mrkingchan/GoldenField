//
//  AdvertiseView.m
//  GoldenField
//
//  Created by Macx on 2018/5/17.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "AdvertiseView.h"
#import <WebKit/WebKit.h>

@interface AdvertiseView()<WKNavigationDelegate> {
    UIButton *_jump;
    WKWebView*_webView;
    NSInteger  _seconds;
    NSTimer *_timer;
    NSString *_url;
}
@end

@implementation AdvertiseView

+ (instancetype)advertiseVieWithURL:(NSString *)urlStr showSeconds:(NSInteger)showSeconds {
    return [[AdvertiseView alloc] initWithURL:urlStr showSeconds:showSeconds];
}

- (instancetype)initWithURL:(NSString *)urlStr showSeconds:(NSInteger)showSeconds {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _seconds = showSeconds;
        _url = urlStr;
        self.backgroundColor = [UIColor clearColor];
        [self setUI];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    return self;
}

#pragma mark  -- setUI
- (void)setUI {
    _webView = [[WKWebView alloc] initWithFrame:self.bounds];
    _webView.navigationDelegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:kURL(_url)]];
    [self addSubview:_webView];
    
    _jump = InsertButtonWithType(self, CGRectMake(kScreenWidth - 120 , 20, 100, 40), 34343, self, @selector(jumpAction), UIButtonTypeCustom);
    [_jump setTitle:[NSString stringWithFormat:@"跳过%zd",_seconds] forState:UIControlStateNormal];
    _jump.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [_jump setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _jump.titleLabel.font =kFontSize(16);
    _jump.clipsToBounds = YES;
    _jump.layer.cornerRadius = 5.0;
    _jump.hidden = YES;
}

#pragma mark  -- private Method
- (void)jumpAction {
    [_timer invalidate];
    _timer = nil;
    [self removeFromSuperview];
}

- (void)timeAction:(NSTimer *)timer {
    if (_seconds > 1) {
        _seconds --;
        [_jump setTitle:[NSString stringWithFormat:@"跳过%zd",_seconds] forState:UIControlStateNormal];
    }else {
        [_timer invalidate];
        _timer = nil;
        [self removeFromSuperview];
    }
}

#pragma mark  -- WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    _jump.hidden = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self selector:@selector(timeAction:)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
}
@end

//
//  LoadingTipView.m
//  GoldFullOfField
//
//  Created by Macx on 2018/5/15.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "LoadingTipView.h"


@interface LoadingTipView() {
    UIActivityIndicatorView *_loadingView;
}
@end

static LoadingTipView *shareLoadingView = nil;

@implementation LoadingTipView

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareLoadingView = [[LoadingTipView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 50, [UIScreen mainScreen].bounds.size.height/2 - 50, 80, 80)];
    });
    return shareLoadingView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        _loadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(frame.size.width / 2 - 40, frame.size.height /2 - 40, 80, 80)];
        _loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _loadingView.hidden = YES;
        [self addSubview:_loadingView];
    }
    return self;
}

/*+(LoadingTipView *)loading {
    LoadingTipView *loadinView = [LoadingTipView shareInstance];
    [loadinView  loading];
    return loadinView;
}

+ (LoadingTipView *)loadFail {
    LoadingTipView *loadinView = [LoadingTipView shareInstance];
    [loadinView  loadingFail];
    return loadinView;
}

+ (LoadingTipView *)loadSucess {
    LoadingTipView *loadinView = [LoadingTipView shareInstance];
    [loadinView  loadSucess];
    return loadinView;
}*/

- (void)loading {
    _loadingView.hidden = NO;
    [_loadingView startAnimating];
}

- (void)loadingFail {
    [_loadingView stopAnimating];
}
- (void)loadSucess {
    [_loadingView stopAnimating];
    [self  removeFromSuperview];
}
@end

//
//  ScreenShotView.m
//  GoldenField
//
//  Created by Macx on 2018/6/20.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "ScreenShotView.h"

@interface ScreenShotView () {
    UIImageView *_imageView;
    UIImage *_image;
}
@end

@implementation ScreenShotView


// MARK: - class method
+ (instancetype)screenShotViewWithScreenImage:(UIImage *)image complete:(void (^)(UIImage *))complete {
    return [[ScreenShotView alloc]initWithScreenImage:image complete:complete];
}

// MARK: - initialized method
- (instancetype)initWithScreenImage:(UIImage *)image complete:(void (^)(UIImage *))complete {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _image = image;
        _completeBlock = complete;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [self setUI];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    return self;
}

// MARK: - setUI
- (void)setUI {
    _imageView = InsertImageView(self, CGRectMake(20, -kScreenHeight, kScreenWidth - 40, kScreenHeight - 40), _image);
    _imageView.image = _image;
    @weakify(self);
    [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        @strongify(self);
        self->_imageView.top = 20;
    } completion:^(BOOL finished) {
        
    }];
    self.userInteractionEnabled = YES;
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_imageView addGestureRecognizer:tap];
}

// MARK: - private Method
- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (_completeBlock) {
        _completeBlock(_image);
    }
    @weakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        @strongify(self);
        self->_imageView.top =  kScreenHeight;
        
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

// MARK: - memory management

- (void)dealloc {
    if (_imageView) {
        _imageView = nil;
    }
    if (_image) {
        _image = nil;
    }
}

// MARK: - loadData

- (void)loadData {
    @weakify(self);
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:kBaseURL]
                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                     @strongify(self);
                                     if (data.length) {
                                         self->_imageView.image = [[UIImage alloc] initWithData:data];
                                     }
                                 }]resume];
}
@end

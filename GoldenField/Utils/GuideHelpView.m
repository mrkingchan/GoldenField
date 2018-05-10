//
//  GuideHelpView.m
//  GoldenField
//
//  Created by Chan on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "GuideHelpView.h"

@interface GuideHelpView() <UIScrollViewDelegate> {
    UIScrollView *_contentView;
    NSArray* _imageArray;
    void (^completeBlock)(void);
}
@end

@implementation GuideHelpView

+ (instancetype)guidehelpViewWithImageArray:(NSArray *)imageArray complete:(void(^)(void))complete {
    return [[GuideHelpView alloc] initWithImageArray:imageArray complete:complete];
}

- (instancetype)initWithImageArray:(NSArray *)imageArray complete:(void(^)(void))complete {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        completeBlock = complete;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        _imageArray = imageArray;
        _contentView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _contentView.contentSize = CGSizeMake(imageArray.count * kScreenWidth, 0);
        _contentView.pagingEnabled = YES;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.delegate = self;
        [self addSubview:_contentView];
        
        //指引页面
        for (int i = 0; i < imageArray.count; i ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, kScreenHeight)];
            imageView.image = imageArray[i];
            imageView.userInteractionEnabled = YES;
            imageView.tag = 1000 + i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTapAction:)];
            [imageView addGestureRecognizer:tap];
            [_contentView addSubview:imageView];
        }
    }
    return self;
}

#pragma mark  -- private Method
- (void)imageViewTapAction:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag;
    if (index != _imageArray.count - 1) {
        [_contentView setContentOffset:CGPointMake(kScreenWidth *(index + 1), 0) animated:YES];
    } else {
        [self hide];
    }
}

- (void)hide {
    [UIView  animateWithDuration:0.1 animations:^{
        [self removeFromSuperview];
        if (self->completeBlock) {
            self->completeBlock();
        }
    }];
}

#pragma mark  -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x> (_imageArray.count - 1) * kScreenWidth) {
        [self hide];
    }
}


@end

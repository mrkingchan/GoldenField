//
//  ChanView.m
//  GoldenField
//
//  Created by Macx on 2018/5/11.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "ChanView.h"

@implementation ChanView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.userInteractionEnabled = YES;
    NSInteger count = 0;
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberofRowsInChanView:)]) {
        count = [_dataSource numberofRowsInChanView:self];
    }
    if (count >0) {
        UIView *subViews[count];
        CGFloat itemW = self.frame.size.width / 3; //每行排列3个
        CGFloat itemH = self.frame.size.height / 3;
        for (int i = 0; i < count; i ++) {
            NSInteger row = i / 3;
            NSInteger column = i %3;
            subViews[i] = InsertView(self, CGRectMake(column * itemW, row * itemH, itemW, itemH), kColorClear);
            if (_dataSource) {
                subViews[i].backgroundColor = [_dataSource backgroudColorInChanView:self];
            }
            subViews[i].tag = i + 1000;
            subViews[i].userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [subViews[i] addGestureRecognizer:tap];
        }
    } else {
        NSAssert(count > 0, @"subView count can't be zero!");
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag - 1000;
    if (self.delegate && [_delegate respondsToSelector:@selector(chanView:didSelectIndex:)]) {
        [_delegate chanView:self didSelectIndex:index];
    } else {
        puts(__func__);
    }
}
@end

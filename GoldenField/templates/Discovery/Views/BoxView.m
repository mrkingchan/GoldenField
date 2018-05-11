//
//  BoxView.m
//  GoldenField
//
//  Created by Chan on 2018/5/8.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "BoxView.h"
#define kgap 2

@interface BoxView () {
    UIImageView *_imageViews[9];
}
@end
@implementation BoxView

+ (CGFloat)boxHeightWithPictureArray:(NSArray *)items {
    CGFloat itemW = (kScreenWidth -20 - 80)/3.0;
    NSInteger rows = (items.count - 1)/3 + 1 ; //行号
    return  itemW * rows + ((rows + 1) * kgap);
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGFloat itemW = (kScreenWidth -20 - 80)/3.0;
        for (int i = 0; i < 9; i  ++) {
            NSInteger rows = i /3;
            NSInteger colum = i %3;
           _imageViews[i]  = InsertImageView(self, CGRectMake(kgap *  (colum + 1) + (colum * itemW), kgap * (rows + 1) + (rows * itemW), itemW, itemW),nil);
            _imageViews[i].userInteractionEnabled = YES;
        }
    }
    return self;
}

- (void)buttonAction:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag - 1000;
    if (_complete) {
        _complete(index,_items);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(boxView:selectedIndex:items:)]) {
        [_delegate boxView:self selectedIndex:index items:_items];
    }
}

-(void)setBoxViewWithData:(NSArray *)items {
    _items = items;
    self.userInteractionEnabled = YES;
    for (int i = 0; i < items.count; i ++) {
        _imageViews[i].image = kIMAGE(items[i]);
        _imageViews[i].tag = 1000 + i;
        UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonAction:)];
        [_imageViews[i] addGestureRecognizer:tap];
    }
}

@end

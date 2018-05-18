//
//  SharePanel.m
//  GoldFullOfField
//
//  Created by Macx on 2018/5/17.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "SharePanel.h"

@interface SharePanel () {
    NSArray *_items;
    NSArray *_images;
    UIView *_contentView;
}
@end

@implementation SharePanel
+ (instancetype)sharePanelWithTitleArray:(NSArray *)titleArray
                              ImageArray:(NSArray *)imageArray
                                complete:(void (^)(NSString *selectedItem,NSInteger index ))complete {
    return [[SharePanel alloc] initWithTitleArray:titleArray
                                       ImageArray:imageArray
                                         complete:complete];
}

- (instancetype)initWithTitleArray:(NSArray *)titleArray
                        ImageArray:(NSArray *)imageArray
                          complete:(void (^)(NSString *selectedItem,NSInteger index ))complete {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _completeBlock = complete;
        _items = titleArray;
        _images = imageArray;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [self setUI];
    }
    return self;
}

- (void)setUI {
    _contentView = InsertView(self, CGRectMake(0, kScreenHeight, kScreenWidth,0) , kColorWhite);
    CGFloat itemW = 40;
    CGFloat titleH = 20;
    UIView *views[_images.count];
    CGFloat subContentViewW = kScreenWidth / 4;
    CGFloat subContentViewH = 80;
    
    UIImageView *imageViews[_images.count];
    UILabel *_titleLabels[_images.count];
    for (int i = 0; i < _items.count; i  ++) {
        NSInteger column = i %4;
        NSInteger row = i /4;
        views[i] = InsertView(_contentView, CGRectMake(column * subContentViewW, 5 * (row + 1) +row * subContentViewH, subContentViewW, subContentViewH), kColorWhite);
        views[i].userInteractionEnabled = YES;

        views[i].tag = 10044 + i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonAction:)];
        [views[i] addGestureRecognizer:tap];
        
        imageViews[i] = InsertImageView(views[i], CGRectMake(subContentViewW / 2 - (itemW / 2), 0, itemW, itemW), _images[i]);
        
        _titleLabels[i] = InsertLabel(views[i], CGRectMake(0, imageViews[i].bottom +5, subContentViewW, titleH), 1, _items[i], kFontSize(14), kColorBlack, NO);
    }

    InsertView(_contentView,CGRectMake(0,views[_items.count - 1].bottom + 4,kScreenWidth,1), kColorBlack);
    UIButton *_cancel = InsertButtonWithType(_contentView, CGRectMake(0, views[_images.count - 1].bottom  + 5, kScreenWidth, 39), 3354, self, @selector(buttonAction:), UIButtonTypeCustom);
    [_cancel setTitleColor:kColorBlack forState:UIControlStateNormal];
    [_cancel setTitle:@"取消" forState:UIControlStateNormal];
    _cancel.titleLabel.textAlignment = 1;
    _cancel.titleLabel.font = kFontSize(16);
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         _contentView.height = _cancel.bottom;
                         _contentView.top = kScreenHeight - _contentView.height;
                     }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.top = kScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)buttonAction:(id)sender  {
    if ([sender isKindOfClass:[UIButton class]]) {
        [self hide];
    } else if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
        NSInteger index = tap.view.tag -10044;
        [self hide];
        if (_completeBlock) {
            _completeBlock(_items[index],index);
        }
    }
}
@end

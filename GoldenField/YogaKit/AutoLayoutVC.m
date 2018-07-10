//
//  AutoLayoutVC.m
//  GoldenField
//
//  Created by Macx on 2018/7/10.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "AutoLayoutVC.h"

@interface AutoLayoutVC ()

@end

@implementation AutoLayoutVC

// MARK: - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"YogaKit等间距自动定宽";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view configureLayoutWithBlock:^(YGLayout *layout) {
        layout.isEnabled = YES;
    }];
    UIScrollView *scrollView = [[UIScrollView alloc] init] ;
    scrollView.backgroundColor = [UIColor grayColor];
    [scrollView configureLayoutWithBlock:^(YGLayout *layout) {
        layout.isEnabled = YES;
        layout.flexDirection = YGFlexDirectionColumn;
        layout.height = YGPointValue(self.view.bounds.size.height);
    }];
    [self.view addSubview:scrollView];
    
    UIView *container =[UIView new];
    container.backgroundColor = [UIColor cyanColor];
    [scrollView addSubview: container];
    [container configureLayoutWithBlock:^(YGLayout * layout) {
        layout.isEnabled = YES;
        layout.justifyContent =  YGJustifySpaceBetween;
        layout.alignItems     =  YGAlignCenter;
        layout.paddingVertical = YGPointValue(20);
    }];
    
    for ( int i = 1 ; i <= 10 ; i++ ) {
        UIView *item = [UIView new];
        item.backgroundColor = [UIColor colorWithHue:(arc4random() % 256 / 256.0) saturation:( arc4random() % 128 / 256.0 ) + 0.5
                                          brightness:( arc4random() % 128 / 256.0 ) + 0.5
                                               alpha:1];
        // 布局
        [item  configureLayoutWithBlock:^(YGLayout *layout) {
            layout.isEnabled = YES;
            layout.marginTop = YGPointValue(15);
            layout.height     = YGPointValue(10*i);
            layout.width      = YGPointValue(10*i);
        }];
        [container addSubview: item];
    }
    [self.view.yoga applyLayoutPreservingOrigin: YES];
    scrollView.contentSize = container.bounds.size;
    
}

// MARK: - memory management
- (void)dealloc {

}
@end

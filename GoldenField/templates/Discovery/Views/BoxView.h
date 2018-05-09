//
//  BoxView.h
//  GoldenField
//
//  Created by Macx on 2018/5/8.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BoxView;

@protocol BoxViewDelegate

- (void)boxView:(BoxView*)boxView selectedIndex:(NSInteger)index items:(NSArray *)items;

@end

@interface BoxView : UIView

+ (CGFloat)boxHeightWithPictureArray:(NSArray *)items;

- (void)setBoxViewWithData:(NSArray *)items;

@property(nonatomic,strong)NSArray *items;

@property(nonatomic,copy) void (^complete)(NSInteger index,NSArray *itmes);

@property(nonatomic,weak)id <BoxViewDelegate>delegate;


@end

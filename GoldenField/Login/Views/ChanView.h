//
//  ChanView.h
//  GoldenField
//
//  Created by Chan on 2018/5/11.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChanView;

@protocol DataSource <NSObject>

@required

- (NSInteger)numberofRowsInChanView:(ChanView *)chanView;

- (UIColor *)backgroudColorInChanView:(ChanView *)chanView;

@end

@protocol ChanDelegate <NSObject>

- (void)chanView:(ChanView*)chanView didSelectIndex:(NSInteger)index;

@end

@interface ChanView : UIView

@property(nonatomic,weak)id <DataSource>dataSource;

@property(nonatomic,weak)id <ChanDelegate>delegate;


@end

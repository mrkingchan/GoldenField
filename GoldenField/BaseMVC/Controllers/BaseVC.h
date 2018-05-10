//
//  BaseVC.h
//  GoldenField
//
//  Created by Chan on 2018/5/7.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingAndRefreshView.h"

@interface BaseVC : UIViewController

@property(nonatomic,strong)NSMutableArray *tasks;

/**
 验证登录
 @param complete 验证登录
 */
- (void)verifyLogin:(void(^)(void))complete;

/**
 添加网络操作队列

 @param task 网络任务
 */
-(void)addNet:(NSURLSessionDataTask *)task;


- (void)releaseNetWork;


#pragma mark  -- loadingView
//加载成功
- (UIView *)loadingSuccess;
// 开始加载转圈view
- (UIView *)loadingStartBgClear;

// 开始加载转圈view,不带背景色，可带往下偏移量
- (UIView *)loadingStartBgClearWithOffset:(CGFloat)offset;
// 开始加载
- (UIView *)loadingStart;
// 开始加载(带头部)
- (UIView *)loadingStartWithOffset:(CGFloat)offset;
// 加载失败未带头部高度
- (UIView *)loadingFail;
- (UIView *)loadingFailWithTitle:(NSString *)title;
- (UIView *)loadingFailWithTitle:(NSString *)title imageStr:(NSString *)imageStr;
// 加载失败带头部高度
- (UIView *)loadingFailWithOffset:(CGFloat)offset;
- (UIView *)loadingFailWithOffset:(CGFloat)offset title:(NSString *)title;
- (UIView *)loadingFailWithOffset:(CGFloat)offset title:(NSString *)title imageStr:(NSString *)imageStr;
// 没有数据未带头部高度
- (UIView *)loadingBlank;
- (UIView *)loadingBlankWithTitle:(NSString *)title;
- (UIView *)loadingBlankWithTitle:(NSString *)title imageStr:(NSString *)imageStr;
// 没有数据带头部高度
- (UIView *)loadingBlankWithOffset:(CGFloat)offset;
- (UIView *)loadingBlankWithOffset:(CGFloat)offset title:(NSString *)title;
- (UIView *)loadingBlankWithOffset:(CGFloat)offset title:(NSString *)title imageStr:(NSString *)imageStr;
- (UIView *)loadingBlankWithOffset:(CGFloat)offset title:(NSString *)title imageStr:(NSString *)imageStr buttonTitle:(NSString *)buttonTitle;

//刷新加载 交给子类去重写
- (void)refreshClick;

@end

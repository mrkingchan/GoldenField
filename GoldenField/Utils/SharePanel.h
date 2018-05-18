//
//  SharePanel.h
//  GoldFullOfField
//
//  Created by Macx on 2018/5/17.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharePanel : UIView

@property(nonatomic,copy) void (^completeBlock)(NSString *selectedItem,NSInteger index);


/**
 自定义分享面板

 @param titleArray 标题
 @param imageArray 图片
 @param complete 点击之后的回调
 @return instanceType
 */
+ (instancetype)sharePanelWithTitleArray:(NSArray *)titleArray
                              ImageArray:(NSArray *)imageArray
                                complete:(void (^)(NSString *selectedItem,NSInteger index ))complete;

@end

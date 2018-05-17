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

+ (instancetype)sharePanelWithTitleArray:(NSArray *)titleArray
                              imageArray:(NSArray *)imageArray
                                complete:(void (^)(NSString *selectedItem,NSInteger index ))complete;

@end

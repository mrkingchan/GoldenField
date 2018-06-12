//
//  UIView+ChangeThem.h
//  GoldenField
//
//  Created by Chan on 2018/5/29.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIView (ChangeThem)

@property(nonatomic,strong)NSMutableDictionary<NSString*,UIColor *> *colorInfo;

@end

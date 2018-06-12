//
//  UIColor+Hex.h
//  LaunchScreenTest
//
//  Created by shenglanya on 2018/5/10.
//  Copyright © 2018年 shenglanya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)


/**
 十六进制的颜色值

 @param string 颜色字符串
 @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)string;


/**
 带alpa值的颜色

 @param string hexStr
 @param alpha alpha透明度
 @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)string alpha:(CGFloat)alpha;

@end

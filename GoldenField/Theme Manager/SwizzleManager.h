//
//  SwizzleManager.h
//  GoldenField
//
//  Created by Chan on 2018/5/29.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwizzleManager : NSObject


/**
 交换实例方法

 @param orginClass class
 @param originSelector 原始方法
 @param swappedSelector 替换方法
 */
+ (void)swizzelInstanceMethodWithClass:(Class)orginClass
                          originSelector:(SEL)originSelector
                         swappedSelector:(SEL)swappedSelector;



/**
 交换类方法

 @param originClass class
 @param originSelector 原始类方法
 @param swappedSelector 替换类方法
 */
+ (void)swizzleClassMethodWithClass:(Class)originClass
                       originSelector:(SEL)originSelector
                      swappedSelector:(SEL)swappedSelector;

@end

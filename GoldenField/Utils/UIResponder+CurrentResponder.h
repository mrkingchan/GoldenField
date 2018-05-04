//
//  UIResponder+CurrentResponder.h
//  RenCaiYingHang
//
//  Created by Chan on 2018/3/23.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (CurrentResponder)


/**
  获取第一响应者
 @return first responder
 */
+ (id)currentFirstResponder;

@end

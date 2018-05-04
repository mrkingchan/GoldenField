//
//  UIResponder+CurrentResponder.m
//  RenCaiYingHang
//
//  Created by Chan on 2018/3/23.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "UIResponder+CurrentResponder.h"

static __weak id currentFirstResponder;

@implementation UIResponder (CurrentResponder)

+ (id)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

- (void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
}

@end

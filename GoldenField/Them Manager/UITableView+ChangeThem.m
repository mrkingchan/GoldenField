//
//  UITableView+ChangeThem.m
//  GoldenField
//
//  Created by Chan on 2018/5/30.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "UITableView+ChangeThem.h"

@implementation UITableView (ChangeThem)

+ (void)load {
    
}

+ (void)swizzleColor {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [SwizzleManager swizzelInstanceMethodWithClass:[self class]
                                        originSelector:@selector(setBackgroundColor:)
                                       swappedSelector:@selector(swizzleSetBackgroundColor:)];
    });
}

- (void)swizzleSetBackgroundColor:(UIColor *)newColor {
    
}
@end

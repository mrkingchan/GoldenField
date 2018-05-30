//
//  UILabel+ChangeThem.m
//  GoldenField
//
//  Created by Chan on 2018/5/30.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "UILabel+ChangeThem.h"

@implementation UILabel (ChangeThem)

+ (void)load {
//    [self swizzleColor];
}

+ (void)swizzleColor {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [SwizzleManager swizzelInstanceMethodWithClass:[self class]
                                        originSelector:@selector(setTextColor:)
                                       swappedSelector:@selector(swizzleSetTextColor:)];
        
        [SwizzleManager swizzelInstanceMethodWithClass:[self class]
                                        originSelector:@selector(setBackgroundColor:)
                                       swappedSelector:@selector(swizzleSetBackgroundColor:)];
    });
}

// MARK: - swizzle SetBackgroundColor & setTextColor

- (void)swizzleSetTextColor:(UIColor *)newColor {
    UIColor *textColor = [[ThemManager shareManager] colorWithReciever:self selectorStr:[NSString stringWithFormat:@"%ld:textColor",self.tag]];
    if (textColor) {
        [self swizzleSetTextColor:textColor];
        [self.colorInfo  setValue:textColor forKey:@"setTextColor:"];
    } else {
        [self swizzleSetTextColor:newColor];
    }
}

- (void)swizzleSetBackgroundColor:(UIColor *)newColor {
    UIColor *backgroundColor = [[ThemManager shareManager] colorWithReciever:self selectorStr:[NSString stringWithFormat:@"%ld:viewBackgroundColor",self.tag]];
    if (backgroundColor) {
        [self swizzleSetBackgroundColor:backgroundColor];
        [self.colorInfo setValue:backgroundColor forKey:@"setBackgroundColor:"];
    } else {
        [self swizzleSetBackgroundColor:newColor];
    }
}


/*
// MARK: -  add Property
-(NSMutableDictionary *)colorInfo {
    return objc_getAssociatedObject(self, @selector(colorInfo));
}

- (void)setColorInfo:(NSMutableDictionary *)colorInfo {
    objc_setAssociatedObject(self, @selector(colorInfo), colorInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThem) name:ThemChangeNotification object:nil];
}

- (void)updateThem {
    [self.colorInfo enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, UIColor * _Nonnull obj, BOOL * _Nonnull stop) {
        SEL selector = NSSelectorFromString(key);
        [UIView animateWithDuration:0.3
                         animations:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                             [self performSelector:selector withObject:obj];
#pragma clang diagnostic pop
                         }];
    }];
}
 */

@end

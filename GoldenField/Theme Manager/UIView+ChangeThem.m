//
//  UIView+ChangeThem.m
//  GoldenField
//
//  Created by Chan on 2018/5/29.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "UIView+ChangeThem.h"

@implementation UIView (ChangeThem)

+ (void)load {
//    [self swizzleColor];
}

+ (void)swizzleColor {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //背景色
        [SwizzleManager swizzelInstanceMethodWithClass:[self class]
                                        originSelector:@selector(setBackgroundColor:)
                                       swappedSelector:@selector(swizzleSetBackgroundColor:)];
        //选染色
        [SwizzleManager swizzleClassMethodWithClass:[self class]
                                     originSelector:@selector(setTintColor:)
                                    swappedSelector:@selector(swizzleSetTintColor:)];
    });
}

// MARK: - setBackgroundColor &setTintColor
- (void)swizzleSetBackgroundColor:(UIColor *)newBackgroundColor {
    UIColor *backgroundColor = [[ThemManager shareManager] colorWithReciever:self selectorStr:[NSString stringWithFormat:@"%ld:viewBackgroundColor",(long)self.tag]];
    if (backgroundColor) {
        [self swizzleSetBackgroundColor:backgroundColor];
        [self.colorInfo  setValue:backgroundColor forKey:@"setBackgroundColor:"];
    } else {
        [self swizzleSetBackgroundColor:newBackgroundColor];
    }
}

- (void)swizzleSetTintColor:(UIColor *)newTintcolor {
    UIColor *tintColor = [[ThemManager shareManager] colorWithReciever:self selectorStr:[NSString stringWithFormat:@"%ld:setTintColor",(long)self.tag]];
    if (tintColor) {
        [self swizzleSetTintColor:tintColor];
        [self.colorInfo  setValue:tintColor forKey:@"setTintColor:"];
    } else {
        [self swizzleSetTintColor:newTintcolor];
    }
}

- (NSMutableDictionary<NSString *,UIColor *> *)colorInfo {
    NSMutableDictionary <NSString *, UIColor *> *colorInfo = objc_getAssociatedObject(self, @selector(colorInfo));
    if (!colorInfo) {
        colorInfo = @{}.mutableCopy;
        objc_setAssociatedObject(self, @selector(colorInfo), colorInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThems) name:ThemChangeNotification object:nil];
    }
    return colorInfo;
}

- (void)updateThems {
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

// MARK: - add property
/*- (NSMutableDictionary<NSString *,UIColor* > *)colorInfo {
    return  objc_getAssociatedObject(self, @selector(colorInfo));
}

-(void)setcolorInfo:(NSMutableDictionary<NSString *,UIColor *> *)colorInfo {
    objc_setAssociatedObject(self, @selector(colorInfo), colorInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThems) name:ThemChangeNotification object:nil];
}*/

@end

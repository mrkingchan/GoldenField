//
//  ThemManager.m
//  GoldenField
//
//  Created by Chan on 2018/5/29.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "ThemManager.h"

NSString * const ThemChangeNotification = @"ThemChangeNotificationName";
NSString * const ThemChangeKey =  @"ThemChangekey";

@implementation ThemManager

+ (instancetype)shareManager {
    static ThemManager *shareInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstace = [[ThemManager alloc] init];
        shareInstace.themType = [kUserDefaultValueForKey(ThemChangeKey) integerValue] ?:ThemChangeTypeDefault;
        
    });
    return shareInstace;
}

- (instancetype)init {
    if (self = [super init]) {
        [self addObserver:self forKeyPath:@"themType" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"themType"]) {
        //
    }
}

-(void)setThemType:(ThemChangeType)themType {
    _themType = themType;
    kUserDefaultSetValue(ThemChangeKey, @(themType));
    kSynchronize;
    
    //根据不同的themType去加载不同的皮肤
    
    NSString *colorPath = nil;
    NSString *tagPath = nil;
    switch (themType) {
        case ThemChangeTypeDefault:
        {
            colorPath = [[NSBundle mainBundle] pathForResource:@"ThemDefault" ofType:@"plist"];
            tagPath = [[NSBundle mainBundle] pathForResource:@"ThemDefaultTag" ofType:@"plist"];
        }
            break;
        case ThemChangeTypeNight:
        {
            colorPath = [[NSBundle mainBundle] pathForResource:@"ThemeNight" ofType:@"plist"];
            tagPath = [[NSBundle mainBundle] pathForResource:@"ThemeNightTag" ofType:@"plist"];
        }
            break;
        case ThemChangeTypeValue1:
            break;
        case ThemChangeTypeValue2:
            break;
        default:
            break;
    }
    _colorInfo = [NSDictionary dictionaryWithContentsOfFile:colorPath];
    _specialColorInfo = [NSDictionary dictionaryWithContentsOfFile:tagPath];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ThemChangeNotification object:nil];
}

// MARK: - getColor

-(UIColor *)colorWithReciever:(id)reciever selectorStr:(NSString *)selectorStr {
    return [UIColor colorWithHexString:_colorInfo[selectorStr]];
}

-(UIColor *)colorWithReciever:(id)reciever tag:(NSInteger)tag selectorStr:(NSString *)selectorStr {
    return [UIColor colorWithHexString:_specialColorInfo[selectorStr]];
    
}
@end

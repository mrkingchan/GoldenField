//
//  ThemManager.h
//  GoldenField
//
//  Created by Chan on 2018/5/29.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+Hex.h"

extern NSString * const ThemChangeNotification;

extern NSString * const ThemChangeKey;


typedef NS_ENUM(NSInteger, ThemChangeType) {
    ThemChangeTypeDefault = 0,
    ThemChangeTypeNight,
    ThemChangeTypeValue1,
    ThemChangeTypeValue2
};

@interface ThemManager : NSObject


@property(nonatomic,assign) ThemChangeType themType;


@property(nonatomic,strong)NSDictionary *colorInfo;

@property(nonatomic,strong)NSDictionary *specialColorInfo;

+ (instancetype)shareManager;

- (UIColor *)colorWithReciever:(id)reciever
                   selectorStr:(NSString *)selectorStr;

- (UIColor *)colorWithReciever:(id)reciever
                           tag:(NSInteger)tag
                   selectorStr:(NSString *)selectorStr;

@end

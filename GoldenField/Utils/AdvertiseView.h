//
//  AdvertiseView.h
//  GoldenField
//
//  Created by Chan on 2018/5/17.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvertiseView : UIView

/**
 广告页
 @param urlStr url
 @param showSeconds 持续时长
 @return 
 */
+ (instancetype)advertiseVieWithURL:(NSString *)urlStr
                        showSeconds:(NSInteger)showSeconds;

@end

//
//  ScreenShotView.h
//  GoldenField
//
//  Created by Macx on 2018/6/20.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenShotView : UIView

@property(nonatomic,copy) void (^completeBlock)(UIImage *image);

+ (instancetype)screenShotViewWithScreenImage:(UIImage *)image
                                     complete:(void(^)(UIImage *image))complete;


@end

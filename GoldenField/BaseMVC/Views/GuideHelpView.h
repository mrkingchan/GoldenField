//
//  GuideHelpView.h
//  GoldenField
//
//  Created by Macx on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuideHelpView : UIView

+ (instancetype)guidehelpViewWithImageArray:(NSArray *)imageArray complete:(void(^)(void))complete;

@end

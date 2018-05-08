//
//  LoginVC.h
//  GoldenField
//
//  Created by Chan on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController

@property(nonatomic,copy) void (^complete)(void);

-(instancetype)initWithLoginCompleteBlock:(void (^)(void))complete;

@end

//
//  BaseVC.h
//  GoldenField
//
//  Created by Chan on 2018/5/7.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseVC : UIViewController

@property(nonatomic,strong)NSMutableArray *tasks;

/**
 验证登录
 @param complete 验证登录
 */
- (void)verifyLogin:(void(^)(void))complete;


-(void)addNet:(NSURLSessionDataTask *)task;

@end

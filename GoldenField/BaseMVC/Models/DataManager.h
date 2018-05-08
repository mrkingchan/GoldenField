//
//  DataManager.h
//  GoldenField
//
//  Created by Chan on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

#define kAppUser [DataManager shareInstance].model

@interface DataManager : NSObject

+ (instancetype)shareInstance;

@property(nonatomic,strong)UserModel *model;

@end

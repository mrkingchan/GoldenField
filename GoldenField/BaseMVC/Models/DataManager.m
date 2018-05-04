//
//  DataManager.m
//  GoldenField
//
//  Created by Macx on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "DataManager.h"

static DataManager *manager = nil;
@implementation DataManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DataManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        NSMutableArray *items = [UserModel searchWithWhere:[NSString stringWithFormat:@"userid = '%@'",@""]];
        for (UserModel *model in items) {
            if (model.isLogin) {
                self.model = model;
                break;
            }
        }
    }
    return self;
}


@end

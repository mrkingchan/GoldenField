//
//  HealthVC.m
//  GoldenField
//
//  Created by Macx on 2018/7/10.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "HealthVC.h"
#import <HealthKit/HealthKit.h>
@interface HealthVC () {
    HKHealthStore *_store;
}

@end

@implementation HealthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![HKHealthStore isHealthDataAvailable]) {
        
    }
}

@end

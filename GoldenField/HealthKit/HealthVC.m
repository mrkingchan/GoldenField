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

// MARK: - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (![HKHealthStore isHealthDataAvailable]) {
        iToastText(@"不支持健康数据管理！");
        return;
    }
    _store = [HKHealthStore new];
    
    //读取健康数据类别
    NSSet *readObjectTypes = [NSSet setWithObjects:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning],
                              [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling],
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                            [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWheelchair],
#pragma clang diagnostic pop
                              [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned],
                              [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned],
                              nil];
    

    //请求授权 会弹出授权页面
    [_store requestAuthorizationToShareTypes:nil
                                   readTypes:readObjectTypes
                                  completion:^(BOOL success, NSError *error)  {
                                      if (!success) {
                                           //不允许
                                      }
                                      if (error) {
                                          iToastText(error.localizedDescription);
                                      }
    }];
    
    
    
    //获取每一天的健康数据
    HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = 1;
    HKStatisticsCollectionQuery *collectionQuery = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:nil options: HKStatisticsOptionCumulativeSum | HKStatisticsOptionSeparateBySource anchorDate:[NSDate dateWithTimeIntervalSince1970:0] intervalComponents:dateComponents];
    
    collectionQuery.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection * __nullable result, NSError * __nullable error) {
        //查询结果
        for (HKStatistics *statistic in result.statistics) {
            NSLog(@"\n%@ 至 %@", statistic.startDate, statistic.endDate);
            for (HKSource *source in statistic.sources) {
                if ([source.name isEqualToString:[UIDevice currentDevice].name]) {
                    NSLog(@"%@ -- %f",source, [[statistic sumQuantityForSource:source] doubleValueForUnit:[HKUnit countUnit]]);
                }
            }
        }
    };
    //执行查询
    [_store executeQuery:collectionQuery];
}

// MARK: - memory management
- (void)dealloc {
    if (_store) {
        _store = nil;
    }
}
@end

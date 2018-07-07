//
//  RespondeData.h
//  GoldenField
//
//  Created by Macx on 2018/6/6.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RespondeData : NSObject

@property(nonatomic,strong)NSString *responseCode;

@property(nonatomic,strong)NSString *responseMessage;

@property(nonatomic,strong)NSDictionary *responseData;


@end

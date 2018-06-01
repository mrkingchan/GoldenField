//
//  WXManager.h
//  GoldenField
//
//  Created by Macx on 2018/5/31.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WXApi.h>
#import <WXApiObject.h>

@interface WXManager : NSObject <WXApiDelegate>

+ (instancetype)shareManager;

+ (void)registerWXWithAppID:(NSString *)appID;

- (void)sendReq:(BaseReq *)req;

@end

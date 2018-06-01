//
//  WXManager.m
//  GoldenField
//
//  Created by Macx on 2018/5/31.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "WXManager.h"

static WXManager *shareInstance = nil;
@implementation WXManager

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[WXManager alloc] init];
    });
    return shareInstance;
}

+(void)registerWXWithAppID:(NSString *)appID {
    [WXApi registerApp:appID];
}

- (void)sendReq:(BaseReq *)req {
    [WXApi sendReq:req];
}

// MARK: -  支付结果
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        //支付结果
        PayResp *payResult = (PayResp *)resp;
        if (payResult.errCode == 0) {
            //支付结果
            [[NSNotificationCenter defaultCenter] postNotificationName:kWeChatPaySucessNotification object:nil];
        } else {
            if (DEBUG) {
                NSLog(@"payResult = %@",payResult.errStr);
            }
        }
    }
}
@end

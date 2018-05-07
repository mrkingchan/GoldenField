//
//  HttpClient.m
//  GoldenField
//
//  Created by Macx on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "HttpClient.h"
static HttpClient *shareClient = nil;

@implementation HttpClient

+ (instancetype)shareClient {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareClient = [[HttpClient alloc] initWithBaseURL:kURL(kBaseURL)];
    });
    return shareClient;
}
@end

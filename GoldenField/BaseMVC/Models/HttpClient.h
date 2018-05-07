//
//  HttpClient.h
//  GoldenField
//
//  Created by Macx on 2018/5/4.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kHttpClient [HttpClient shareClient]

@interface HttpClient : AFHTTPSessionManager

+ (instancetype)shareClient;

@end

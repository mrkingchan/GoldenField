//
//  NetTool.h
//  GoldenField
//
//  Created by Chan on 2018/5/7.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    GET,
    POST,
    PUT,
    DELETE,
    PATCH,
    HEAD
}HttpMethod;

@interface NetTool : NSObject


/**
 网络请求
 @param method requestMethod 请求方法
 @param urlStr url
 @param params 请求参数
 @param target target
 @param sucess 成功回调
 @param failure 失败回调
 @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)innerRequestWithHttpMethod:(HttpMethod)method
                                              urlStr:(NSString *)urlStr
                                              params:(id)params
                                              target:(id)target
                                              sucess:(void(^)(id responseObject))sucess
                                             failure:(void(^)(NSString *errorStr))failure;

// MARK:  -- GET & POST
+ (NSURLSessionDataTask *)innerPostWithUrl:(NSString *)urlStr
                                    params:(id)params
                                    target:(id)target
                                    sucess:(void(^)(id responseData))sucess
                                   failure:(void(^)(NSString *errorStr))failure;

+ (NSURLSessionDataTask *)innerGetWithUrl:(NSString *)urlStr
                                    params:(id)params
                                    target:(id)target
                                    sucess:(void(^)(id responseData))sucess
                                  failure:(void(^)(NSString *errorStr))failure;
@end

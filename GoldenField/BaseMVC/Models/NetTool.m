//
//  NetTool.m
//  GoldenField
//
//  Created by Chan on 2018/5/7.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "NetTool.h"
#import "HttpClient.h"

@interface NetTool() {
    
}
@end

@implementation NetTool

+ (NSURLSessionDataTask *)innerRequestWithHttpMethod:(HttpMethod)method
                                              urlStr:(NSString *)urlStr
                                              params:(id)params
                                              target:(id)target
                                              sucess:(void(^)(id responseObject))sucess
                                             failure:(void(^)(NSString *errorStr))failure {
    
#if DEBUG
    NSLog(@"request ------------->%@%@\n%@",kBaseURL,urlStr,params);
#else
    
#endif
    
    NSString *methodStr = nil;
    switch (method) {
        case GET:
            methodStr = @"GET";
            break;
        case POST:
            methodStr = @"POST";
            break;
        case PUT:
            methodStr = @"PUT";
            break;
        case DELETE:
            methodStr = @"DELETE";
            break;
        case HEAD:
            methodStr = @"HEAD";
            break;
            case PATCH:
            methodStr = @"PATCH";
            break;
        default:
            break;
    }
    NSURLSessionDataTask *task = [kHttpClient dataTaskWithHTTPMethod:methodStr
                                                            URLString:urlStr
                                                           parameters:params
                                                       uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
                                                           
                                                       } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
                                                           
                                                       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                                           //转json
                                                           id json = [[self class] transformResponseObejctToJson:responseObject url:urlStr];
                                                           sucess(json);
                                                       } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                                           NSString *errorStr = error.localizedDescription;
                                                           if (failure) {
                                                               failure(errorStr);
                                                           }
                                                           /*if ([target respondsToSelector:@selector(loadingFail)]) {
                                                               [target performSelectorOnMainThread:@selector(loadingFail) withObject:nil waitUntilDone:NO];
                                                           }*/
                                                       }];
    [task resume];
    if ([target respondsToSelector:@selector(addNet:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:@selector(addNet:) withObject:task];
#pragma clang diagnostic pop
    }
    return task;
}

+ (id)transformResponseObejctToJson:(id)responseObject url:(NSString *)urlStr{
    id json;
    if ([responseObject isKindOfClass:[NSData class]]) {
        NSData *jsonData = [((NSString *)responseObject) dataUsingEncoding:NSUTF8StringEncoding];
        json = [NSJSONSerialization JSONObjectWithData:jsonData
                                               options:kNilOptions
                                                 error:nil];
    }
#if DEBUG
    NSLog(@"response---------->%@%@\n%@",kBaseURL,urlStr,json);
#else
    
#endif
    return json ?:@{};
}

// MARK:  -- GET & POST
+ (NSURLSessionDataTask *)innerPostWithUrl:(NSString *)urlStr
                                    params:(id)params
                                    target:(id)target
                                    sucess:(void(^)(id responseData))sucess
                                   failure:(void(^)(NSString *errorStr))failure {
    
    return [[self class] innerRequestWithHttpMethod:POST
                                            urlStr:urlStr
                                            params:params
                                            target:target
                                            sucess:sucess
                                           failure:failure];
}


+ (NSURLSessionDataTask *)innerGetWithUrl:(NSString *)urlStr
                                    params:(id)params
                                    target:(id)target
                                    sucess:(void(^)(id responseData))sucess
                                  failure:(void(^)(NSString *errorStr))failure {
    return [[self class] innerRequestWithHttpMethod:GET
                                             urlStr:urlStr
                                             params:params
                                             target:target
                                             sucess:sucess
                                            failure:failure];
}

+ (NSURLSessionDataTask *)innerPostWithUrl:(NSString *)urlStr
                                 paramters:(id)parameters
                                    target:(id)target
                                    sucess:(void(^)(id responseObject))sucess
                                   failure:(void(^)(NSString *errorStr))failure{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:kURL(urlStr)];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:parameters
                                                       options:kNilOptions
                                                         error:nil];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSString *errorStr = error.localizedDescription;
            if (failure) {
                failure(errorStr);
            }
        } else {
            id json = [NSJSONSerialization JSONObjectWithData:data
                                                      options:kNilOptions
                                                        error:nil];
            if (DEBUG) {
                NSLog(@"-------->%@\%@%@",kBaseURL,urlStr,json);
            }
            if (sucess) {
                sucess(json);
            }
        }
    }];
    if (target) {
        if ([target respondsToSelector:@selector(addNet:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:@selector(addNet:) withObject:task];
#pragma clang diagnostic pop
        }
    }
    return task;
}

@end


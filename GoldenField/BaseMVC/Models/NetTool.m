//
//  NetTool.m
//  GoldenField
//
//  Created by Macx on 2018/5/7.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "NetTool.h"
#import "HttpClient.h"

@implementation NetTool

+ (NSURLSessionDataTask *)innerRequestWithHttpMethod:(HttpMethod)method
                                              urlStr:(NSString *)urlStr
                                              params:(id)params
                                              target:(id)target
                                              sucess:(void(^)(id responseObject))sucess
                                             failure:(void(^)(NSString *errorStr))failure {
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
    NSURLSessionDataTask *task  = [kHttpClient dataTaskWithHTTPMethod:methodStr
                                                            URLString:urlStr
                                                           parameters:params
                                                       uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
                                                           
                                                       } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
                                                           
                                                       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                                           sucess(responseObject);
                                                           
                                                       } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                                           NSString *errorStr = error.localizedDescription;
                                                           if (failure) {
                                                               failure(errorStr);
                                                           }
                                                       }];
    return task;
    
}
@end

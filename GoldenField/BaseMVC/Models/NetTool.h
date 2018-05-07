//
//  NetTool.h
//  GoldenField
//
//  Created by Macx on 2018/5/7.
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

+ (NSURLSessionDataTask *)innerRequestWithHttpMethod:(HttpMethod)method
                                              urlStr:(NSString *)urlStr
                                              params:(id)params
                                              target:(id)target
                                              sucess:(void(^)(id responseObject))sucess
                                             failure:(void(^)(NSString *errorStr))failure;

@end

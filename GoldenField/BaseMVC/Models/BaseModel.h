//
//  BaseModel.h
//  GoldenField
//
//  Created by Chan on 2018/5/9.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseModel.h"
#import "NetTool.h"

@interface BaseModel : NSObject <NSCoding>

#pragma mark  -- 子类继承与BaseModel

- (id)modelToJson;

+ (id)jsonToModel:(NSDictionary*)json;

///数据库地址
+ (NSString *)downloadPath;



/**
 responseModel里的核心数据是data

 @param httpMethod httpMethod
 @param urlStr  url请求路径
 @param paramters 请求参数
 @param target target 一般是baseViewController
 @param sucess 成功回调
 @return  NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)innerRequestWithHttpMethod:(HttpMethod)httpMethod
                                              urlStr:(NSString *)urlStr
                                           paramters:(id)paramters
                                              target:(id)target
                                              sucess:(void (^)(ResponseModel *model))sucess;



@end

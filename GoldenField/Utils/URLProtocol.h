//
//  Protocol.h
//  WKWebViewProtocol
//
//  Created by Macx on 2018/4/25.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface URLProtocol : NSURLProtocol <NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property(nonatomic,strong)NSURLSessionDataTask *task;

@property(nonatomic,strong)NSURLConnection *connection;

@property(nonatomic,strong)NSURLSession *session;

@end

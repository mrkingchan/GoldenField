//
//  Protocol.m
//  WKWebViewProtocol
//
//  Created by Chan on 2018/4/25.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "URLProtocol.h"
static NSString * const URLProtocolHandledKey = @"Chan";

@implementation URLProtocol

/*
函数调用的依次
 +[Protocol canInitWithRequest:]
 +[Protocol canonicalRequestForRequest:]
 +[Protocol canInitWithRequest:]
 +[Protocol canInitWithRequest:]
 +[Protocol canInitWithRequest:]
 +[Protocol canInitWithRequest:]
 +[Protocol canInitWithRequest:]
 +[Protocol canonicalRequestForRequest:]
 +[Protocol canonicalRequestForRequest:]
 2018-04-25 10:06:43.072509+0800 WKWebViewProtocol[6991:1250925] 被拦截的url = https://www.baidu.com
 -[Protocol startLoading]
 */

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    puts(__func__);
    if ([request.URL.absoluteString rangeOfString:@"qianft.com"].length) {
        return NO;
    }
    if ([[NSURLProtocol propertyForKey:URLProtocolHandledKey inRequest:request] boolValue]) {
        return NO;
    }
    //YES:URL Loading System会创建一个CustomURLProtocol实例然后调用NSURLConnection去获取数据
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    puts(__func__);
    NSMutableURLRequest *mutableRequest  = [request mutableCopy];
    [mutableRequest setValue:@"Chan" forHTTPHeaderField:@"UDID"];
    [mutableRequest setValue:@"Chan" forHTTPHeaderField:@"token"];
    return mutableRequest;
}

- (void)startLoading {
      /*NSMutableURLRequest* request = self.request.mutableCopy;
    [NSURLProtocol setProperty:@YES forKey:FilteredKey inRequest:request];
    NSData* data = UIImagePNGRepresentation([UIImage imageNamed:@"image"]);
    NSURLResponse* response = [[NSURLResponse alloc] initWithURL:self.request.URL MIMEType:@"image/png" expectedContentLength:data.length textEncodingName:nil];
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    [self.client URLProtocol:self didLoadData:data];
    [self.client URLProtocolDidFinishLoading:self];*/
    //在+ (BOOL)canInitWithRequest:(NSURLRequest *)request 里面返回的YES的request就会到达这里 做处理
    NSString *urlStr = self.request.URL.absoluteString;
    [NSURLProtocol setProperty:@(YES) forKey:URLProtocolHandledKey inRequest:[self.request mutableCopy]];
    NSLog(@"被拦截的url = %@,requestheaders = %@",self.request.URL.absoluteString,self.request.allHTTPHeaderFields);
    //这里的处理的是所有被拦截下来的请求的处理
    puts(__func__);
    if ([UIDevice currentDevice].systemVersion.floatValue >=7.0) {
        _session = [NSURLSession sharedSession];
        _task = [_session dataTaskWithRequest:self.request];
        [_task resume];
    } else {
        _connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:YES];
    }
}

- (void)stopLoading {
    puts(__func__);
    if (_session) {
        _session = nil;
    }
    if (_task) {
        [_task cancel];
        _task  = nil;
    }
    
    if (_connection) {
        [_connection cancel];
        _connection = nil;
    }
}

// MARK:  -- NSURLConnectionDelegate &&NSURLConnectionDataDelegate

@end

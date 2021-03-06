//
//  NetTool.swift
//  GoldenField
//
//  Created by Chan on 2018/5/18.
//  Copyright © 2018年 Chan. All rights reserved.
//

import Foundation

class NetManager: NSObject {
    
    // MARK: - NSURLSession
    
    /// 网络请求
    ///
    /// - Parameters:
    ///   - httpmethod: 请求方法
    ///   - urlStr: 请求url
    ///   - parameters: 参数
    ///   - sucess: 成功回调
    ///   - failure: 失败回调
    /// - Returns: URLSessionDataTask
    class func request(httpMethod httpmethod:String,urlStr:String,parameters:Any,sucess:@escaping ( _ repsoneData:Any)->(),failure:@escaping (_ errorStr:String)->()) -> URLSessionDataTask {
        
        let session = URLSession.shared;
        var request:URLRequest = URLRequest.init(url: URL.init(string: urlStr as String)!) as URLRequest;
        request.httpBody =  try?JSONSerialization.data(withJSONObject: parameters, options: []);
        request.httpMethod = httpmethod;
        let dataTask = session.dataTask(with:request) { (responseData, response, error) in
            if error != nil {
                failure((error?.localizedDescription)!);
            } else {
                let json = try? JSONSerialization.jsonObject(with: responseData!, options: []) as Any;
                sucess(json!);
            }
        }
        dataTask.resume();
        return dataTask;
    }
    
    // MARK: - POST
   class func POST(urlStr:String,
                   paramters:Any,
                   sucess:@escaping (_ responseData:Any)->(),
                   failure:@escaping(_ errorStr:String)->()) -> URLSessionDataTask {
    return self.request(httpMethod: "POST",
                        urlStr: urlStr,
                        parameters: paramters,
                        sucess: sucess,
                        failure: failure);
    }
    
    // MARK: - GET
    func GET(urlStr:String,paramters:Any,sucess:@escaping (_ responseData:Any)->(),failure:@escaping(_ errorStr:String)->()) -> URLSessionDataTask {
        return self.classForCoder.request(httpMethod: "GET",
                                          urlStr: urlStr,
                                          parameters: paramters,
                                          sucess: sucess,
                                          failure: failure);
    }
    
    
    // MARK: - NSURLConnection
    
    func requestConnection(urlStr:String,
                           httpmethodStr:String,
                           paramtes:Any,
                           sucess:@escaping (_ responseData:AnyObject)->(),
                           failure:@escaping ( _ errorStr:String)->()) -> Void {
        let requestURL:URL = URL.init(string: urlStr)!;
        var request:URLRequest = URLRequest.init(url:requestURL);
        request.httpBody = try? JSONSerialization.data(withJSONObject: paramtes, options: []);
        request.httpMethod = httpmethodStr;
        NSURLConnection.sendAsynchronousRequest(request,
                                                queue: OperationQueue.main) { (response, data, error) in
                                                    if error != nil {
                                                        failure(error!.localizedDescription);
                                                    } else {
                                                        let json = try? JSONSerialization.jsonObject(with: data!, options: []);
                                                        sucess(json! as AnyObject);
                                                    }
        }
        
    }
    
    // MARK: - GET
    func requestGetConnection(urlStr:String,
                              parametes:AnyObject,
                              sucess:@escaping (_ responseObject:AnyObject)->(),
                              failure:@escaping (_ errorStr:String)->()) -> Void {
        return  self.requestConnection(urlStr: urlStr,
                                       httpmethodStr: "GET",
                                       paramtes: parametes,
                                       sucess: sucess,
                                       failure: failure);
    }
    
    
    // MARK: - POST
    func requestPOSTConnection(urlStr:String,
                              parametes:AnyObject,
                              sucess:@escaping (_ responseObject:AnyObject)->(),
                              failure:@escaping (_ errorStr:String)->()) -> Void {
        return  self.requestConnection(urlStr: urlStr,
                                       httpmethodStr: "POST",
                                       paramtes: parametes,
                                       sucess: sucess,
                                       failure: failure);
    }
    
}

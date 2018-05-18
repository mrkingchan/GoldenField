//
//  NetTool.swift
//  GoldenField
//
//  Created by Macx on 2018/5/18.
//  Copyright © 2018年 Chan. All rights reserved.
//

import Foundation

class NetManager: NSObject {
    
    
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
        return dataTask;
        let tool = Tool.init();
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
}

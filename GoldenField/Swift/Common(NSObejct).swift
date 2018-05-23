//
//  Common.swift
//  GoldenField
//
//  Created by Chan on 2018/5/18.
//  Copyright © 2018年 Chan. All rights reserved.
//

import Foundation
import UIKit
extension NSObject {
    
    // MARK: - kImage
    func kImage(imageName:String) -> UIImage {
        let image = UIImage.init(named: imageName);
//        image?.renderingMode = UIImageRenderingMode.alwaysOriginal;
        return image!;
    }
    
    // MARK: - Int -> Float
    func kIntToFloat(value:Int) -> CGFloat {
        return CGFloat(value);
    }
    
    // MARK: - URL
    func kURL(urlStr:String) -> URL {
        return URL.init(string: urlStr)!;
    }
    
    // MARK: - iOSVersion
    func kiOSVersion() -> Float {
        return Float(UIDevice.current.systemVersion)!;
    }

    // MARK: - data to json
    func kDataToJson(_ data:Data) -> Any {
        let json = try? JSONSerialization.jsonObject(with: data, options: []);
        return json!;
    }

    // MARK: - json to Data
    func kJsonToData(json:Any) -> Data {
        let jsonData =  try? JSONSerialization.data(withJSONObject: json, options: []);
        return jsonData!;
    }
    
    // MARK: - kScreenWidth & Height
    func kScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width;
    }
    
    func kScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height;
    }
}

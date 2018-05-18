//
//  Common.swift
//  GoldenField
//
//  Created by Macx on 2018/5/18.
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
    
    
    
}

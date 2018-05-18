//
//  TabbarController.swift
//  GoldenField
//
//  Created by Macx on 2018/5/18.
//  Copyright © 2018年 Chan. All rights reserved.
//

import Foundation
import UIKit

class TabbarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad();
        self.view.backgroundColor = UIColor.white;
    }
    
    /// 构建指定类名的ViewController
    ///
    /// - Parameters:
    ///   - className: className
    ///   - titleStr: titleStr
    ///   - normalImage: normalImage
    ///   - selectedImage: selectedImage
    /// - Returns: UIViewController
    func buildController(_ className:AnyClass,titleStr:String,normalImage:UIImage, selectedImage:UIImage) -> UIViewController {
        return UIViewController.init(nibName: nil, bundle: nil);
    }
}

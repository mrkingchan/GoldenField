//
//  BaseController.swift
//  GoldenField
//
//  Created by Macx on 2018/5/18.
//  Copyright © 2018年 Chan. All rights reserved.
//

import Foundation
import UIKit

class BaseController: UIViewController {
    var _tasks:NSMutableArray?;
    override func viewDidLoad() {
        super.viewDidLoad();
        self.view.backgroundColor = UIColor.white;
        if #available(iOS 11.0, *) {
            self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0);
        }
        _tasks = NSMutableArray.init();
    }
    // MARK: - private Method
    func adddNet(_ net:URLSessionDataTask) -> Void {
        _tasks?.add(net);
    }
}

//
//  BaseController.swift
//  GoldenField
//
//  Created by Chan on 2018/5/18.
//  Copyright © 2018年 Chan. All rights reserved.
//

import Foundation
import UIKit
//import LocalAuthentication

class BaseController: UIViewController {
    var _tasks:NSMutableArray?;
    override func viewDidLoad() {
        super.viewDidLoad();
        
        /*let context = LAContext();
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "touchID") { (sucess, error) in
                
            }
        } else {
            print("")
        }*/
        
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

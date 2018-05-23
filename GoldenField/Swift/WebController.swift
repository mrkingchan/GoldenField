//
//  WebController.swift
//  GoldenField
//
//  Created by Chan on 2018/5/18.
//  Copyright © 2018年 Chan. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WebController: UIViewController {
    var _webView:WKWebView?;
    var _configuration:WKWebViewConfiguration?;
    var _url:String?;
    
    // MARK: - lifeCircle
    override func viewDidLoad() {
        super.viewDidLoad();
        self.view.backgroundColor = UIColor.white;
        _configuration = WKWebViewConfiguration.init();
        _configuration?.userContentController = WKUserContentController.init();
        _webView = WKWebView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: self.view.bounds.size.height), configuration: _configuration!);
        self.view.addSubview(_webView!);
        _webView?.load(URLRequest.init(url: URL.init(string:_url!)!));
    }
    
    // MARK: - loadURL
    func loadUrl(url:String) {
        _webView?.load(URLRequest.init(url: URL.init(string: url)!));
    }
    
    
    // MARK: - UITableViewDataSource &Delegate
    
    func numberofRows(_ seciton:Int, tableView:UITableView) -> Int {
        return 100;
    }
    
    func cellForRow(_ tableView:UITableView,indexPath:NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell");
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell");
        }
        return cell!;
    }
    
    
    func heightForRow(_ tableView:UITableView, indexPath:NSIndexPath) -> CGFloat {
        return 100;
    }
    
    func numbeofSection(_ tableView:UITableView) -> Int {
        return 10;
    }
}


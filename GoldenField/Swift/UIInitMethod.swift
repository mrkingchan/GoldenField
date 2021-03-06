//
//  Tool.swift
//  GoldenField
//
//  Created by Chan on 2018/5/18.
//  Copyright © 2018年 Chan. All rights reserved.
//

import Foundation
import UIKit
import WebKit

extension  NSObject {
    
    // MARK: - UIView
     func InsertView(_ superView:UIView,rect:CGRect,backgroundColor:UIColor) -> UIView {
        let view = UIView.init(frame: rect) as UIView;
        superView.addSubview(view);
        view.backgroundColor = backgroundColor;
        return view;
    }
    
    // MARK: - UITableView
    
     func InsertTableView(_ superview:UIView,rect:CGRect,dataSource:Any,delegate:Any) -> UITableView {
        let tableView = UITableView.init(frame: rect);
        tableView.dataSource = dataSource as? UITableViewDataSource;
        tableView.delegate = delegate as? UITableViewDelegate;
        superview.addSubview(tableView);
        return tableView;
    }
    
    // MARK: - UICollectionView
    
    func InsertCollectionView(_ superView:UIView,rect:CGRect,itemSize:CGSize,interSpacing:CGFloat,lineSpacing:CGFloat, dataSource:Any,delegate:Any)
        -> UICollectionView {
            let flowlayout = UICollectionViewFlowLayout.init();
            flowlayout.itemSize = itemSize;
            flowlayout.minimumLineSpacing = lineSpacing;
            flowlayout.minimumInteritemSpacing = interSpacing;
           let collectionView = UICollectionView.init(frame: rect, collectionViewLayout: flowlayout);
            collectionView.dataSource = dataSource as?  UICollectionViewDataSource;
            collectionView.delegate = delegate as? UICollectionViewDelegate;
            return collectionView;
    }
    
    // MARK: - UILabel
      func InsertLabel(_ superview:UIView,rect:CGRect,backgroundColor:UIColor,font:UIFont,textAlignment:NSTextAlignment,textColor:UIColor,textStr:String) -> UILabel {
        let label = UILabel.init(frame: rect);
        label.text = textStr;
        label.font = font;
        label.backgroundColor = backgroundColor;
        label.textAlignment = textAlignment;
        label.textColor = textColor;
        superview.addSubview(label);
        return label;
    }
    
    // MARK: - UIButton
    
    func InsertButton(_ superView:UIView,rect:CGRect,backgroundColor:UIColor,titleColor:UIColor,titleFont:UIFont,textAlignment:NSTextAlignment,text:String,tag:Int,target:Any,selector:Selector) -> UIButton {
        let button = UIButton.init(type: UIButtonType.custom);
        button.frame = rect;
        button.setTitle(text, for: UIControlState.normal);
        button.setTitleColor(titleColor, for: UIControlState.normal);
        button.backgroundColor = backgroundColor;
        button.titleLabel?.font = titleFont;
        button.titleLabel?.textAlignment = textAlignment;
        button.tag = tag;
        button.addTarget(target, action:selector, for: UIControlEvents.touchUpInside);
        superView.addSubview(button);
        return button;
    }
    
    // MARK: - UIImageView
     func InsertImageView(_ superView:UIView,rect:CGRect,image:UIImage) -> UIImageView {
        let imageView = UIImageView.init(frame: rect);
        imageView.image = image;
        superView.addSubview(imageView);
        return imageView;
    }
    
    // MARK: - InsertPageControl
    
    func InsertPageControl(_ superView:UIView,rect:CGRect,currentPage:Int,pageIndicatorColor:UIColor,currentPageIndicatorColor:UIColor,numberofPage:Int) -> UIPageControl {
        let pageControl = UIPageControl.init(frame: rect);
        pageControl.currentPage =  currentPage;
        pageControl.pageIndicatorTintColor = pageIndicatorColor;
        pageControl.currentPageIndicatorTintColor = currentPageIndicatorColor;
        pageControl.numberOfPages = numberofPage;
        superView.addSubview(pageControl);
        return pageControl;
    }
    
    func kIntoFloat(value:Int) -> CGFloat {
        return CGFloat(value);
    }
    
    // MARK: - UIAlertController
    func InsertAlerController(_ title:String,messageStr:String,alertStyle:UIAlertControllerStyle,button1Title:String?,button1Action:@escaping ((_ title1:String)->()),button2Title:String?,button2Action:@escaping ((_ title2:String)->()),targetController:UIViewController) ->UIAlertController {
        let alertController = UIAlertController.init(title: title, message: messageStr, preferredStyle: alertStyle);
        if button1Title != nil {
            alertController.addAction(UIAlertAction.init(title: button1Title, style: UIAlertActionStyle.default, handler: { (alertAction) in
                button1Action(alertAction.title!);
            }));
        }
        if button2Title != nil {
            alertController.addAction(UIAlertAction.init(title: button2Title!, style: UIAlertActionStyle.default, handler: { (alertAction) in
                button2Action(alertAction.title!);
            }));
        }
        targetController.present(alertController, animated: true, completion: nil);
        return alertController;
    }
    
    // MARK: - UIActionSheet
    func InsertActionSheet(title:String,messageStr:String,button1Title:String?,button1Action:@escaping ((_ title:String)->()),button2Title:String?,button2Action:@escaping((_  title:String)->()),targetController:UIViewController) -> UIAlertController{
        let actionSheet = UIAlertController.init(title: title, message: messageStr, preferredStyle: UIAlertControllerStyle.actionSheet);
        if button1Title != nil {
            actionSheet.addAction(UIAlertAction.init(title: button1Title, style: UIAlertActionStyle.default, handler: { (alertAction) in
                button1Action(alertAction.title!);
            }));
        }
        
        if button2Title != nil {
            actionSheet.addAction(UIAlertAction.init(title: button2Title, style: UIAlertActionStyle.default, handler: { (alertAction) in
                button2Action(alertAction.title!);
            }));
        }
        //cancel
        actionSheet.addAction(UIAlertAction.init(title:"取消", style: UIAlertActionStyle.cancel,
                                                 handler: nil));
        targetController.present(actionSheet, animated: true, completion: nil);
        return actionSheet;
    }
    
    // MARK: - webView
    func InsertWebView(rect:CGRect, delegate:Any,url:String) -> UIWebView {
        let webView = UIWebView(frame: rect);
        webView.dataDetectorTypes = UIDataDetectorTypes.all;
        webView.delegate = delegate as? UIWebViewDelegate;
        return webView;
    }
    
    func InsertWKWwebView(rect:CGRect,navigationDelegate:Any,configuration:WKWebViewConfiguration) -> WKWebView  {
        let webView = WKWebView.init(frame: rect, configuration: configuration);
        webView.navigationDelegate = navigationDelegate as? WKNavigationDelegate;
        return webView;
    }
}


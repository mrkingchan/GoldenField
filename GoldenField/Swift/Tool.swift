//
//  Tool.swift
//  GoldenField
//
//  Created by Macx on 2018/5/18.
//  Copyright © 2018年 Chan. All rights reserved.
//

import Foundation
import UIKit

class Tool: NSObject {
    
    // MARK: - UIView
    class func InsertView(_ superView:UIView,rect:CGRect,backgroundColor:UIColor) -> UIView {
        let view = UIView.init(frame: rect) as UIView;
        superView.addSubview(view);
        view.backgroundColor = backgroundColor;
        return view;
    }
    
    // MARK: - UITableView
    
    class func InsertTableView(_ superview:UIView,rect:CGRect,dataSource:Any,delegate:Any) -> UITableView {
        let tableView = UITableView.init(frame: rect);
        tableView.dataSource = dataSource as? UITableViewDataSource;
        tableView.delegate = delegate as? UITableViewDelegate;
        superview.addSubview(tableView);
        return tableView;
    }
    
    // MARK: - UICollectionView
    
    class func InsertCollectionView(_ superView:UIView,rect:CGRect,itemSize:CGSize, dataSource:Any,delegate:Any)
        -> UICollectionView {
            let flowlayout = UICollectionViewFlowLayout.init();
            flowlayout.itemSize = itemSize;
           let collectionView = UICollectionView.init(frame: rect, collectionViewLayout: flowlayout);
            collectionView.dataSource = dataSource as?  UICollectionViewDataSource;
            collectionView.delegate = delegate as? UICollectionViewDelegate;
            return collectionView;
    }
    
    // MARK: - UILabel
     class func InsertLabel(_ superview:UIView,rect:CGRect,backgroundColor:UIColor,font:UIFont,textAlignment:NSTextAlignment,textColor:UIColor,textStr:String) -> UILabel {
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
    
   class func InsertButton(_ superView:UIView,rect:CGRect,backgroundColor:UIColor,titleColor:UIColor,titleFont:UIFont,textAlignment:NSTextAlignment,text:String,tag:Int,target:Any,selector:Selector) -> UIButton {
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
    class func InsertImageView(_ superView:UIView,rect:CGRect,image:UIImage) -> UIImageView {
        let imageView = UIImageView.init(frame: rect);
        imageView.image = image;
        superView.addSubview(imageView);
        return imageView;
    }
    
    func kIntoFloat(value:Int) -> CGFloat {
        return CGFloat(value);
    }
}

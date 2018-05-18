//
//  SharePanel.swift
//  GoldenField
//
//  Created by Macx on 2018/5/18.
//  Copyright © 2018年 Chan. All rights reserved.
//

import Foundation
import UIKit

class ShareView: UIView {
    
    var _contentView:UIView?;
    var _complete:((String,Int)->())?;
    var _titleArray:NSArray?;
    var _imageArray:NSArray?;
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init method not implement!");
    }
    
    class func shareView(_ titleArray:NSArray,imageArray:NSArray,complete:@escaping (_ selectedItem:String,_  inde:Int)->()) -> ShareView {
        return ShareView.init(frame: UIScreen.main.bounds, titleArray: titleArray, imageArray: imageArray, complete: complete);
    }

    
    override init(frame: CGRect) {
        
        super.init(frame: frame);
    }
    
    // MARK: - initial Method
    convenience  init(frame:CGRect, titleArray:NSArray,imageArray:NSArray,complete:@escaping (_ selectedItem:String,_ index:Int)->()) {
        self.init(frame: frame);
        _complete = complete;
        _imageArray = imageArray;
        _titleArray = titleArray;
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7);
        UIApplication.shared.keyWindow?.addSubview(self);
        
        
        _contentView = Tool.InsertView(self, rect: CGRect.init(x: CGFloat(0), y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 80 * 2), backgroundColor: UIColor.white);
        _contentView?.isUserInteractionEnabled = true;
        let ContainerW :CGFloat = UIScreen.main.bounds.size.width  / 4;
        let ContaincerH :CGFloat = 80.0;
        
        for (index,_) in  titleArray.enumerated() {
            let rows = index/4;
            let column = index%4;
            let X = CGFloat(CGFloat(column) * ContainerW);
            let Y = CGFloat(CGFloat(rows) * ContaincerH);
    
            let subView = Tool.InsertView(_contentView!, rect: CGRect.init(x:X, y:Y, width: ContainerW, height: ContaincerH), backgroundColor: UIColor.white);
            subView.isUserInteractionEnabled = true;
            let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self.buttonAction(_:))) ;
            
            subView.addGestureRecognizer(gesture as UIGestureRecognizer);
            
            let imageView = Tool.InsertImageView(subView, rect: CGRect.init(x: ContainerW / 2 - 30, y: 0, width: 60, height: 60), image:imageArray.object(at: index) as! UIImage);
            
            let title = Tool.InsertLabel(subView, rect: CGRect.init(x: 0, y: 60, width: ContainerW, height: 20), backgroundColor: UIColor.white, font: UIFont.systemFont(ofSize: 14), textAlignment: NSTextAlignment.center, textColor: UIColor.black, textStr: titleArray.object(at: index) as! String);
        }
        _contentView?.frame = CGRect.init(x: CGFloat(0), y: UIScreen.main.bounds.size.height - 160, width: UIScreen.main.bounds.size.width, height: 80 * 2);
    }
    
    // MARK: - buttonAction
    
   @objc private func buttonAction(_ sender:Any) {
        hide();
        let tap = sender as! UITapGestureRecognizer;
        let index:Int = (tap.view?.tag)!;
        _complete!(_titleArray?.object(at: index) as! String,index);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.hide();
    }
    
    // MARK: - hide
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.removeFromSuperview();
        }
    }
    
}

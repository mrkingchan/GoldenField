//
//  Position.swift
//  GoldenField
//
//  Created by Chan on 2018/5/18.
//  Copyright © 2018年 Chan. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    // MARK: - X
    public var x: CGFloat{
        
        //get
        get{
            return self.frame.origin.x
        }
        
        //set
        set{
            var r = self.frame;
            r.origin.x = newValue;
            self.frame = r;
        }
    }
    
    // MARK: - Y
    public var y:CGFloat {
        get {
            return self.frame.origin.y;
        }
        
        set {
            var r = self.frame;
            r.origin.y = newValue;
            self.frame = r;
        }
    }
    
    // MARK: - Width
    
    public var width:CGFloat {
        get {
            return self.frame.size.width;
        }
        
        set {
            var r = self.frame;
            r.size.width = newValue;
            self.frame = r;
        }
    }
    
    
    // MARK: - height
    
    public var height:CGFloat {
        get {
            return self.frame.size.height;
        }
        
        set {
            var r = self.frame;
            r.size.height = newValue;
            self.frame = r;
        }
    }
    
    // MARK: - top
    
    public var top:CGFloat{
        get {
            return self.frame.origin.y;
        }
        
        set {
            var r = self.frame;
            r.origin.y = newValue;
            self.frame = r;
        }
    }
    
    // MARK: - bottom
    
    public var bottom:CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height;
        }
        
        set {
            var r = self.frame;
            r.origin.y =  newValue - self.frame.size.height;
            self.frame = r;
        }
    }
    
    // MARK: - left
    public var left:CGFloat {
        
        get {
            return self.frame.origin.x;
        }
        
        set {
            var r = self.frame;
            r.origin.x = newValue;
        }
    }
    
    public var right:CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width;
        }
        set {
            var r = self.frame;
            r.origin.x = newValue - self.frame.size.width;
        }
    }
}



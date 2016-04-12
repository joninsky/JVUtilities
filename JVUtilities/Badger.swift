//
//  Badger.swift
//  JVUtilities
//
//  Created by Jon Vogel on 4/12/16.
//  Copyright © 2016 Jon Vogel. All rights reserved.
//

import Foundation


public extension UIView {
    
    public func setBadgeValue(value: String) {
        
        let circlePath = UIBezierPath(arcCenter: CGPointMake(self.frame.origin.x + self.frame.width, 0), radius: 30, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.CGPath
        shapeLayer.fillColor = UIColor.redColor().CGColor
        shapeLayer.strokeColor = UIColor.blackColor().CGColor
        shapeLayer.lineWidth = 1.0
        
        self.layer.addSublayer(shapeLayer)
        
    }
    
}
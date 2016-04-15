//
//  Badger.swift
//  JVUtilities
//
//  Created by Jon Vogel on 4/12/16.
//  Copyright © 2016 Jon Vogel. All rights reserved.
//

import UIKit

public class Badger: UILabel {
    
    
    public var badgeValue: String = "" {
        willSet(newValue){

        }
        
        didSet{
            self.text = badgeValue
            if self.badgeValue.isEmpty {
                self.hidden = true
            }else{
                self.hidden = false
            }
        }
    }

    public init(badgeColor color: UIColor?, textColor: UIColor?, viewToBadge view: UIView, initialValue value: String?) {
        super.init(frame: CGRectMake(0, 0, 25, 25))
        
        
        
        if color == nil {
            self.backgroundColor = UIColor.redColor()
        }else {
            self.backgroundColor = color
        }
        
        if textColor == nil {
            self.textColor = UIColor.whiteColor()
        }else{
            self.textColor = textColor
        }
        
        self.adjustsFontSizeToFitWidth = true
        self.textAlignment = NSTextAlignment.Center
        self.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.numberOfLines = 0
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        self.constrain(view)
        

        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
        
        if value != nil {
            self.badgeValue = value!
            self.text = value
            if self.text!.isEmpty == true {
                self.hidden = true
            }
        }else{
            self.hidden = true
        }
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func constrain(superView: UIView) {
        
        var arrayOfConstraints = [NSLayoutConstraint]()
        
        let verticalConstraint = NSLayoutConstraint(item: superView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        
        let horizontalConstraint = NSLayoutConstraint(item: superView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        
        let widthConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:[me(>=25)]", options: [], metrics: nil, views: ["me": self])
        
        let heighConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:[me(>=25)]", options: [], metrics: nil, views: ["me":self])
        
        arrayOfConstraints.appendContentsOf(widthConstraint)
        arrayOfConstraints.appendContentsOf(heighConstraint)
        arrayOfConstraints.append(verticalConstraint)
        arrayOfConstraints.append(horizontalConstraint)
        
        superView.addConstraints(arrayOfConstraints)
        
    }
    

}

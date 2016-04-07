//
//  ActivityIndication.swift
//  JVUtilities
//
//  Created by Jon Vogel on 4/6/16.
//  Copyright © 2016 Jon Vogel. All rights reserved.
//

import UIKit

public class ATActivity: UIVisualEffectView {
    
    private let blurEffect: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
    private var vibrancyEffect: UIVibrancyEffect?
    private var vibrancyEffectView: UIVisualEffectView?
    private var activityIndicator: UIActivityIndicatorView?
    private var savingLabel: UILabel?
    private var isAnimating = false
    private var dictionaryOfViews: [String: UIView]?
    
    public init(withSpinnerColor spinnerColor: UIColor?, withBackgroundColor backgroundColor: UIColor?){
        super.init(effect: blurEffect)
        
        if backgroundColor != nil {
            self.backgroundColor = backgroundColor
        }
        
        self.vibrancyEffect =  UIVibrancyEffect(forBlurEffect: blurEffect)
        self.vibrancyEffectView = UIVisualEffectView(effect: self.vibrancyEffect!)
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        if spinnerColor != nil {
            self.activityIndicator?.color = spinnerColor
        }
        
        self.savingLabel = UILabel()
        self.savingLabel?.textAlignment = NSTextAlignment.Center
        self.savingLabel?.numberOfLines = 0
        self.savingLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.savingLabel?.textColor = UIColor.blackColor()
        //self.vibrancyEffectView!.contentView.addSubview(self.activityIndicator!)
        self.contentView.addSubview(self.vibrancyEffectView!)
        self.contentView.addSubview(self.savingLabel!)
        self.contentView.addSubview(self.activityIndicator!)
        
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1.0
        self.clipsToBounds = true
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.vibrancyEffectView?.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        self.savingLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        self.dictionaryOfViews = ["me" : self, "Activity" : self.activityIndicator!, "label" : self.savingLabel!, "Vibrancy": self.vibrancyEffectView!]
        
        self.setUpConstraintsForSubViews(self, otheViews: self.dictionaryOfViews!)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func changeLabel(newText: String) {
        self.savingLabel?.text = newText
    }
    
    public func startAnimating(viewToCover theView: UIView, withMessage: String, coverEntireView: Bool) {
        
        self.savingLabel?.text = withMessage
        
        
        theView.addSubview(self)
        
        
        
        self.setUpConstraintsForMainView(theView, otherViews: self.dictionaryOfViews!, coverEntireView: coverEntireView)
        
        self.isAnimating = true
        //UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        self.activityIndicator!.startAnimating()
        
    }
    
    public func stopAnimating(){
        self.removeFromSuperview()
        //UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
        self.isAnimating = false
        
        self.activityIndicator!.stopAnimating()
    }
    
    
    private func setUpConstraintsForMainView(mainView: UIView, otherViews: [String:AnyObject], coverEntireView: Bool) {
        
        var arrayOfConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
        
        if coverEntireView == true {
            let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[me]|", options: [], metrics: nil, views: otherViews)
            let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[me]|", options: [], metrics: nil, views: otherViews)
            
            for c in verticalConstraints {
                arrayOfConstraints.append(c)
            }
            
            for c in horizontalConstraints {
                arrayOfConstraints.append(c)
            }
            
        }else{
            
            let verticalConstraint = NSLayoutConstraint(item: mainView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
            
            let horizontalConstraint = NSLayoutConstraint(item: mainView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
            
            let heightConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:[me(>=150)]", options: [], metrics: nil, views: otherViews)
            
            let widthConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[me(>=150)]", options: [], metrics: nil, views: otherViews)
            
            for c in heightConstraint {
                arrayOfConstraints.append(c)
            }
            
            for c in widthConstraints {
                arrayOfConstraints.append(c)
            }
            
            arrayOfConstraints.append(verticalConstraint)
            arrayOfConstraints.append(horizontalConstraint)
        }
        
        
        
        
        
        mainView.addConstraints(arrayOfConstraints)
        
    }
    
    private func setUpConstraintsForSubViews(mainView: UIView, otheViews: [String:UIView]) {
        
        var arrayOfConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
        
        let activityIndication = otheViews["Activity"]
        
        let activityVerticalCenter = NSLayoutConstraint(item: activityIndication!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: mainView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        
        let activityHorizontalCenter = NSLayoutConstraint(item: activityIndication!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: mainView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        
        arrayOfConstraints.append(activityVerticalCenter)
        
        arrayOfConstraints.append(activityHorizontalCenter)
        
        let theLabel = otheViews["label"]
        
        let labelHorizontalCenter = NSLayoutConstraint(item: theLabel!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: mainView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        
        arrayOfConstraints.append(labelHorizontalCenter)
        
        let labelVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[label]-8-[Activity]", options: [], metrics: nil, views: otheViews)
        
        let labelHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(>=0)-[label]-(>=0)-|", options: [], metrics: nil, views: otheViews)
        
        let labelWidthConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:[label(<=150)]", options: [], metrics: nil, views: otheViews)
        
        for c in labelVerticalConstraints{
            arrayOfConstraints.append(c)
        }
        
        for c in labelHorizontalConstraints{
            arrayOfConstraints.append(c)
        }
        
        for c in labelWidthConstraint {
            arrayOfConstraints.append(c)
        }
        
        let vibrancyEffectVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[Vibrancy]|", options: [], metrics: nil, views: otheViews)
        
        let vibranctEffectHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[Vibrancy]|", options: [], metrics: nil, views: otheViews)
        
        for c in vibrancyEffectVerticalConstraints{
            arrayOfConstraints.append(c)
        }
        
        for c in vibranctEffectHorizontalConstraints {
            arrayOfConstraints.append(c)
        }
        
        mainView.addConstraints(arrayOfConstraints)
        
    }
    
    
    //End Class
}


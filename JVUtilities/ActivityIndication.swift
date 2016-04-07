//
//  ActivityIndication.swift
//  JVUtilities
//
//  Created by Jon Vogel on 4/6/16.
//  Copyright © 2016 Jon Vogel. All rights reserved.
//

import UIKit

public class ActivityIndication: UIVisualEffectView {
    
    private let blurEffect: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
    private var vibrancyEffect: UIVibrancyEffect?
    private var vibrancyEffectView: UIVisualEffectView?
    private var activityIndicator: UIActivityIndicatorView?
    private var savingLabel: UILabel?
    private var isAnimating = false
    private var dictionaryOfViews: [String: UIView]?
    
    public init(){
        super.init(effect: blurEffect)
        
        self.vibrancyEffect =  UIVibrancyEffect(forBlurEffect: blurEffect)
        self.vibrancyEffectView = UIVisualEffectView(effect: self.vibrancyEffect!)
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        //self.activityIndicator!.color = Colors.pebbleBeeMaroon
        
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
        
        //self.dictionaryOfViews = ["me" : self.contentView, "VisualEffectsView" : self.vibrancyEffectView!.contentView, "Activity" : self.activityIndicator!, "label" : self.savingLabel!]
        self.dictionaryOfViews = ["me" : self, "Activity" : self.activityIndicator!, "label" : self.savingLabel!, "Vibrancy": self.vibrancyEffectView!]
        
        self.setUpConstraintsForSubViews(self, otheViews: self.dictionaryOfViews!)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func changeLabel(newText: String) {
        self.savingLabel?.text = newText
    }
    
    public func startAnimating(viewToCover theView: UIView, withTimer: Bool, withMessage: String, coverEntireView: Bool) {
        
        self.savingLabel?.text = withMessage
        
        
        if withTimer == true {
            _ = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "stopAnimating:", userInfo: nil, repeats: false)
        }
        
        theView.addSubview(self)
        
        
        
        self.setUpConstraintsForMainView(theView, otherViews: self.dictionaryOfViews!, coverEntireView: coverEntireView)
        
        self.isAnimating = true
        //UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        self.activityIndicator!.startAnimating()
        
    }
    
    public func stopAnimating(sender: AnyObject){
        self.removeFromSuperview()
        //UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
        self.isAnimating = false
        
        self.activityIndicator!.stopAnimating()
    }
    
    
    private func setUpConstraintsForMainView(mainView: UIView, otherViews: [String:AnyObject], coverEntireView: Bool) {
        
        var arrayOfConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
        
        var verticalConstraints: [NSLayoutConstraint]?
        
        var horizontalConstraints: [NSLayoutConstraint]?
        
        if coverEntireView == true {
            verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[me]|", options: [], metrics: nil, views: otherViews)
            horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[me]|", options: [], metrics: nil, views: otherViews)
        }else{
            let height = (mainView.frame.height / 2) * 0.65
            let width = (mainView.frame.width / 2) * 0.25
            
            //print(height)
            //print(width)
            verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(height)-[me]-\(height)-|", options: [], metrics: nil, views: otherViews)
            horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(width)-[me]-\(width)-|", options: [], metrics: nil, views: otherViews)
        }
        
        for c in verticalConstraints! {
            arrayOfConstraints.append(c)
        }
        
        for c in horizontalConstraints! {
            arrayOfConstraints.append(c)
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
        
        let labelHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[label]|", options: [], metrics: nil, views: otheViews)
        
        for c in labelVerticalConstraints{
            arrayOfConstraints.append(c)
        }
        
        for c in labelHorizontalConstraints{
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
}

//
//  FlowerMenu.swift
//  JVUtilities
//
//  Created by Jon Vogel on 4/22/16.
//  Copyright © 2016 Jon Vogel. All rights reserved.
//

import UIKit

public protocol FlowerMenuDelegate {
    func flowerMenuDidSelectPedalWithID(theMenu: FlowerMenu, identifier: String, pedal: UIView)
    func flowerMenuDidExpand()
    func flowerMenuDidRetract()
}

public enum Position {
    case UpperRight
    case UpperLeft
    case LowerRight
    case LowerLeft
    case Center
}

public class FlowerMenu: UIImageView {
    
    //MARK: Public Variables
    public var centerView: UIView!
    public var pedals: [UIView] = [UIView]()
    public var pedalSize: CGFloat!
    public var pedalDistance: CGFloat = 100
    public var pedalSpace: CGFloat = 50
    public var startAngle: CGFloat!
    public var growthDuration: NSTimeInterval = 0.4
    public var stagger: NSTimeInterval = 0.06
    public var menuIsExpanded: Bool = false
    public var delegate: FlowerMenuDelegate?
    public var showPedalLabels = false
    public var currentPosition: Position! {
        didSet{
            self.constrainToPosition(self.currentPosition, animate: true)
        }
    }
    //MARK: Private Variables
    var pedalIDs: [String: UIView] = [String: UIView]()
    var positionView: UIView!
    //var theSuperView: UIView!
    
    //MARK: Init functions
    public init(withPosition: Position, andSuperView view: UIView, andImage: UIImage?){
        super.init(image: andImage)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.userInteractionEnabled = true
        view.addSubview(self)
        self.constrainToPosition(withPosition, animate: false)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FlowerMenu.didTapCenterView(_:)))
        self.addGestureRecognizer(tapGesture)
        self.currentPosition = withPosition
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    //MARK: Public functions
    public func addPedal(theImage: UIImage, identifier: String){
        let newPedal = self.createAndConstrainPedal(theImage, name: identifier)
        self.addSubview(newPedal)
        self.constrainPedalToSelf(newPedal)
        self.pedals.append(newPedal)
        self.pedalIDs[identifier] = newPedal
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FlowerMenu.didTapPopOutView(_:)))
        newPedal.addGestureRecognizer(tapGesture)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(FlowerMenu.pannedViews(_:)))
        newPedal.addGestureRecognizer(panGesture)
        newPedal.alpha = 0
    }
    
    public func selectPedalWithID(identifier: String) {
        for key in self.pedalIDs.keys {
            if key == identifier {
                
                guard let view = self.pedalIDs[key] else{
                    return
                }
                
                self.delegate?.flowerMenuDidSelectPedalWithID(self, identifier: key, pedal: view)
            }
        }
    }
    
    public func getPedalFromIdentifier(identifier: String) -> UIView {
        return UIView()
    }
    
    public override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        if CGRectContainsPoint(self.bounds, point) {
            return true
        }
        for view in self.pedals {
            if CGRectContainsPoint(view.frame, point) {
                return true
            }
        }
        return false
    }
    
    public func grow(){
        for (index, view) in self.pedals.enumerate() {
            let indexAsDouble = Double(index)
            UIView.animateWithDuration(self.growthDuration, delay: self.stagger * indexAsDouble, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                view.alpha = 1
                view.transform = self.getTransformForPopupViewAtIndex(CGFloat(index))
                }, completion: { (didComplete) in
                    self.delegate?.flowerMenuDidExpand()
            })
        }
        self.menuIsExpanded = true
    }
    
    public func shrivel(){
        for (index, view) in self.pedals.enumerate() {
            let indexAsDouble = Double(index)
            UIView.animateWithDuration(self.growthDuration, delay: self.stagger * indexAsDouble, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                view.alpha = 0
                view.transform = CGAffineTransformIdentity
                }, completion: { (didComplete) in
                    self.delegate?.flowerMenuDidRetract()
            })
        }
        self.menuIsExpanded = false
    }
    
    internal func didTapPopOutView(sender: UITapGestureRecognizer) {
        for key in self.pedalIDs.keys {
            guard let view = self.pedalIDs[key] else{
                break
            }
            if view == sender.view {
                self.delegate?.flowerMenuDidSelectPedalWithID(self, identifier: key, pedal: view)
            }
        }
    }
    
    internal func didTapCenterView(sender: UITapGestureRecognizer){
        if self.menuIsExpanded {
            self.shrivel()
        }else{
            self.grow()
        }
    }
    
    internal func pannedViews(sender: UIPanGestureRecognizer) {

        guard let theView = sender.view else {
            return
        }
        
        var indexOfView: Int?
        
        for (index, view) in self.pedals.enumerate() {
            if view == theView{
                indexOfView = index
                break
            }
        }
        
        let point = sender.locationInView(self)
        
        let centerX = self.bounds.origin.x + self.bounds.size.width / 2
        
        let centerY = self.bounds.origin.y + self.bounds.size.height / 2
        
        if sender.state == UIGestureRecognizerState.Changed {
            
            let deltaX = point.x - centerX
            
            let deltaY = point.y - centerY
            
            let atan = Double(atan2(deltaX, -deltaY))
            
            let angle = atan * Double(180) / M_PI
            
            self.pedalDistance = sqrt(pow(point.x - centerX, 2) + pow(point.y - centerY, 2))
            
            self.startAngle = CGFloat(angle) - self.pedalSpace * CGFloat(indexOfView!)
            
            theView.center = point
            
            theView.transform = CGAffineTransformIdentity
            
            for (index, aView) in self.pedals.enumerate() {
                if aView != theView {
                    aView.transform = self.getTransformForPopupViewAtIndex(CGFloat(index))
                }
            }
            
        }else if sender.state == UIGestureRecognizerState.Ended {
            theView.center = CGPointMake(centerX, centerY)
            for (index, aView) in self.pedals.enumerate() {
                aView.transform = self.getTransformForPopupViewAtIndex(CGFloat(index))
            }
        }
        
    }
    
    internal func getTransformForPopupViewAtIndex(index: CGFloat) -> CGAffineTransform{
        
        let newAngle = Double(self.startAngle + (self.pedalSpace * index))
        
        let deltaY = Double(-self.pedalDistance) * cos(newAngle / 180 * M_PI)
        
        let deltaX = Double(self.pedalDistance) * sin(newAngle / 180 * M_PI)
        
        return CGAffineTransformMakeTranslation(CGFloat(deltaX), CGFloat(deltaY))
    }
    
    private func createAndConstrainPedal(image: UIImage, name: String) -> UIView {
        
        let newPedal = UIView()
        let pedalImage = UIImageView(image: image)
        let pedalLabel = UILabel()
        
        newPedal.translatesAutoresizingMaskIntoConstraints = false
        pedalImage.translatesAutoresizingMaskIntoConstraints = false
        newPedal.userInteractionEnabled = true
        pedalLabel.userInteractionEnabled = true
        pedalImage.userInteractionEnabled = true
        pedalLabel.translatesAutoresizingMaskIntoConstraints = false
        pedalLabel.numberOfLines = 1
        if self.showPedalLabels == false {
            pedalLabel.text = name
            pedalLabel.hidden = true
        }
        pedalLabel.text = name
        pedalLabel.adjustsFontSizeToFitWidth = true
        
        newPedal.addSubview(pedalImage)
        newPedal.addSubview(pedalLabel)
        
        let dictionaryOfViews = ["image": pedalImage, "label": pedalLabel]
        
        self.constrainPedal(newPedal, pedalSubViews: dictionaryOfViews)
        
        return newPedal
        
    }
    
    //MARK: Constraint Adding
    func constrainToPosition(thePosition: Position, animate: Bool) {
        //self.removeConstraints(self.constraints)
        var arrayOfConstraints = [NSLayoutConstraint]()
        switch thePosition {
        case .Center:
            let verticalConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
            let horizontalConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
            arrayOfConstraints.append(verticalConstraint)
            arrayOfConstraints.append(horizontalConstraint)
            self.startAngle = 0
            print("Constrain To Center")
        case .LowerLeft:
            let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-28-[me]", options: [], metrics: nil, views: ["me": self])
            let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[me]-28-|", options: [], metrics: nil, views: ["me":self])
            arrayOfConstraints.appendContentsOf(horizontalConstraints)
            arrayOfConstraints.appendContentsOf(verticalConstraints)
            self.startAngle = 10
            print("Constrain To Lower Left")
        case .LowerRight:
            let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[me]-28-|", options: [], metrics: nil, views: ["me": self])
            let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[me]-28-|", options: [], metrics: nil, views: ["me":self])
            arrayOfConstraints.appendContentsOf(horizontalConstraints)
            arrayOfConstraints.appendContentsOf(verticalConstraints)
            self.startAngle = -80
            print("Constrain To Lower Right")
        case .UpperLeft:
            let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-28-[me]", options: [], metrics: nil, views: ["me": self])
            let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-28-[me]", options: [], metrics: nil, views: ["me":self])
            arrayOfConstraints.appendContentsOf(horizontalConstraints)
            arrayOfConstraints.appendContentsOf(verticalConstraints)
            print("Constrain To Upper Left")
            self.startAngle = 100
        case .UpperRight:
            let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[me]-28-|", options: [], metrics: nil, views: ["me": self])
            let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-28-[me]", options: [], metrics: nil, views: ["me":self])
            arrayOfConstraints.appendContentsOf(horizontalConstraints)
            arrayOfConstraints.appendContentsOf(verticalConstraints)
            self.startAngle = 170
            print("Constrain To Upper Right")
        }
        
//        let width = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 50)
//        let height = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 50)
//        arrayOfConstraints.append(width)
//        arrayOfConstraints.append(height)
        
        self.superview?.addConstraints(arrayOfConstraints)
        self.setNeedsLayout()
        
        if animate {
            UIView.animateWithDuration(0.5) {
                self.layoutIfNeeded()
            }
        }else{
            self.layoutIfNeeded()
        }
    }
    
    private func constrainPedal(thePedal: UIView, pedalSubViews: [String: AnyObject]){
        
        var arrayOfConstraint = [NSLayoutConstraint]()
        
        let imageLabelVertical = NSLayoutConstraint.constraintsWithVisualFormat("V:|[image][label]|", options: [], metrics: nil, views: pedalSubViews)
        
        let imageHorizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(>=0)-[image]-(>=0)-|", options: [], metrics: nil, views: pedalSubViews)

        guard let theImage = pedalSubViews["image"] as? UIImageView, let label = pedalSubViews["label"] as? UILabel else {
            return
        }
        
        if self.showPedalLabels == false {
            let labeHeight = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0)
            arrayOfConstraint.append(labeHeight)
        }

        let moreImageHorizontal = NSLayoutConstraint(item: theImage, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: thePedal, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        
        let labelHorizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|[label]|", options: [], metrics: nil, views: pedalSubViews)
        
        arrayOfConstraint.appendContentsOf(imageLabelVertical)
        arrayOfConstraint.appendContentsOf(imageHorizontal)
        arrayOfConstraint.append(moreImageHorizontal)
        arrayOfConstraint.appendContentsOf(labelHorizontal)
        thePedal.addConstraints(arrayOfConstraint)
    }
    
    private func constrainPedalToSelf(thePedal: UIView) {
        
        var arrayOfConstraints = [NSLayoutConstraint]()
        
        
        let centerX = NSLayoutConstraint(item: thePedal, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        
        let centerY = NSLayoutConstraint(item: thePedal, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        
        arrayOfConstraints.append(centerX)
        arrayOfConstraints.append(centerY)
        
        self.addConstraints(arrayOfConstraints)
        
    }
    
}


//
//  FlowerMenu.swift
//  JVUtilities
//
//  Created by Jon Vogel on 4/22/16.
//  Copyright © 2016 Jon Vogel. All rights reserved.
//

import UIKit

public protocol FlowerMenuDelegate {
    func flowerMenuDidSelectPedalWithID(theMenu: FlowerMenu, identifier: String)
    func flowerMenuShouldExpand(theMenu: FlowerMenu) -> Bool
    func flowerMenuDidExpand(theMenu: FlowerMenu)
    func flowerMenuShouldRetract(theMenu: FlowerMenu) -> Bool
    func flowerMenuDidRetract(theMenu: FlowerMenu)
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
    public var pedalDistance: CGFloat!
    public var pedalSpace: CGFloat!
    public var startAngle: CGFloat!
    public var growthDuration: NSTimeInterval!
    public var stagger: NSTimeInterval!
    public var menuIsExpanded: Bool = false
    public var delegate: FlowerMenuDelegate?
    public var currentPosition: Position! {
        didSet{
            self.constrainToPosition(self.currentPosition, animate: true)
        }
    }
    //MARK: Private Variables
    var pedalIDs: [String: UIView] = [String: UIView]()
    var positionView: UIView!
    var theSuperView: UIView!
    
    //MARK: Init functions
    public init(withPosition: Position, andSuperView view: UIView){
        super.init(image: nil)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.userInteractionEnabled = true
        self.theSuperView = view
        self.theSuperView?.addSubview(self)
        
        self.constrainToPosition(withPosition, animate: false)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FlowerMenu.didTapCenterView(_:)))
        self.addGestureRecognizer(tapGesture)
        self.currentPosition = withPosition
        self.pedalDistance = 100
        self.pedalSpace = 50
        self.startAngle = 75
        self.stagger = 0.06
        self.growthDuration = 0.4
        self.backgroundColor = UIColor.greenColor()
        print(self.bounds)
        print(self.frame)
        
        print(self.theSuperView.bounds)
        print(self.theSuperView.frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    //MARK: Public functions
    public func addPedal(theView: UIView, identifier: String){
        if theView is UIImageView {
            theView.userInteractionEnabled = true
        }
        
        theView.translatesAutoresizingMaskIntoConstraints = false
        theView.frame = CGRectMake(0, 0, 50, 50)
        self.theSuperView.addSubview(theView)
        //self.addHeightAndWidthToPedal(theView)
        self.theSuperView.sendSubviewToBack(theView)
        theView.layer.cornerRadius = theView.bounds.height / 2
        self.pedals.append(theView)
        self.pedalIDs[identifier] = theView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FlowerMenu.didTapPopOutView(_:)))
        theView.addGestureRecognizer(tapGesture)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(FlowerMenu.pannedViews(_:)))
        theView.addGestureRecognizer(panGesture)
        theView.alpha = 0
        
        theView.center = CGPointMake(self.bounds.origin.x + self.bounds.size.width / 2, self.bounds.origin.y + self.bounds.size.height / 2)
    }
    
    public func getPedalFromIdentifier(identifier: String) -> UIView {
        return UIView()
    }
    
    public func grow(){
        for (index, view) in self.pedals.enumerate() {
            
            let indexAsDouble = Double(index)
            
            UIView.animateWithDuration(self.growthDuration, delay: self.stagger * indexAsDouble, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                view.alpha = 1
                print(self.getTransformForPopupViewAtIndex(CGFloat(index)))
                view.transform = self.getTransformForPopupViewAtIndex(CGFloat(index))
                }, completion: { (didComplete) in
                    self.delegate?.flowerMenuDidExpand(self)
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
                    self.delegate?.flowerMenuDidExpand(self)
            })
        }
        self.menuIsExpanded = false
    }
    
    internal func didTapPopOutView(sender: UITapGestureRecognizer) {
        for key in self.pedalIDs.keys {
            let view = self.pedalIDs[key]
            if view == sender.view {
                print("Tapped Pop Out named: " + key)
                self.delegate?.flowerMenuDidSelectPedalWithID(self, identifier: key)
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
        print("Detecting Pan")
        
    }
    
    internal func getTransformForPopupViewAtIndex(index: CGFloat) -> CGAffineTransform{
        
        let newAngle = Double(self.startAngle + (self.pedalSpace * index))
        
        let deltaY = Double(-self.pedalDistance) * cos(newAngle / 180 * M_PI)
        
        let deltaX = Double(self.pedalDistance) * sin(newAngle / 180 * M_PI)
        
        return CGAffineTransformMakeTranslation(CGFloat(deltaX), CGFloat(deltaY))
    }
    
    //MARK: Constraint Adding
    func constrainToPosition(thePosition: Position, animate: Bool) {
        self.removeConstraints(self.constraints)
        var arrayOfConstraints = [NSLayoutConstraint]()
        switch thePosition {
        case .Center:
            let verticalConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.theSuperView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
            
            let horizontalConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.theSuperView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
            
            arrayOfConstraints.append(verticalConstraint)
            arrayOfConstraints.append(horizontalConstraint)
            print("Constrain To Center")
        case .LowerLeft:
            let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-28-[me]", options: [], metrics: nil, views: ["me": self])
            let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[me]-28-|", options: [], metrics: nil, views: ["me":self])
            arrayOfConstraints.appendContentsOf(horizontalConstraints)
            arrayOfConstraints.appendContentsOf(verticalConstraints)
            print("Constrain To Lower Left")
        case .LowerRight:
            let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[me]-28-|", options: [], metrics: nil, views: ["me": self])
            let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[me]-28-|", options: [], metrics: nil, views: ["me":self])
            arrayOfConstraints.appendContentsOf(horizontalConstraints)
            arrayOfConstraints.appendContentsOf(verticalConstraints)
            print("Constrain To Lower Right")
        case .UpperLeft:
            let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-28-[me]", options: [], metrics: nil, views: ["me": self])
            let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-28-[me]", options: [], metrics: nil, views: ["me":self])
            arrayOfConstraints.appendContentsOf(horizontalConstraints)
            arrayOfConstraints.appendContentsOf(verticalConstraints)
            print("Constrain To Upper Left")
        case .UpperRight:
            let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[me]-28-|", options: [], metrics: nil, views: ["me": self])
            let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-28-[me]", options: [], metrics: nil, views: ["me":self])
            arrayOfConstraints.appendContentsOf(horizontalConstraints)
            arrayOfConstraints.appendContentsOf(verticalConstraints)
            print("Constrain To Upper Right")
        }
        
        self.theSuperView.addConstraints(arrayOfConstraints)
        self.setNeedsLayout()
        
        if animate {
            UIView.animateWithDuration(0.5) {
                self.layoutIfNeeded()
            }
        }else{
            self.layoutIfNeeded()
        }
        
        print(self.bounds)
        print(self.frame)
        
        print(self.theSuperView.bounds)
        print(self.theSuperView.frame)
    }
    
    private func addHeightAndWidthToPedal(thePedal: UIView) {
        
        var arrayOfConstraints = [NSLayoutConstraint]()
        
        
        let width = NSLayoutConstraint.constraintsWithVisualFormat("H:[view(50)]", options: [], metrics: nil, views: ["view":thePedal])
        let height = NSLayoutConstraint.constraintsWithVisualFormat("V:[view(50)]", options: [], metrics: nil, views: ["view":thePedal])
        //        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: ["view":thePedal])
        //        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: ["view":thePedal])
        //        arrayOfConstraints.appendContentsOf(horizontalConstraints)
        //        arrayOfConstraints.appendContentsOf(verticalConstraints)
        arrayOfConstraints.appendContentsOf(width)
        arrayOfConstraints.appendContentsOf(height)
        
        self.theSuperView.addConstraints(constraints)
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
    }
    
}


//
//  FlowerMenuController.swift
//  JVUtilities
//
//  Created by Jon Vogel on 4/16/16.
//  Copyright © 2016 Jon Vogel. All rights reserved.
//

import UIKit



//Make a Container View Controller
//https://developer.apple.com/library/ios/featuredarticles/ViewControllerPGforiPhoneOS/ImplementingaContainerViewController.html

public class FMViewControler: UIViewController, UIViewControllerTransitioningDelegate {
    
    //MARK: Properties
    
    var nextViewButton: UIButton?
    
    //MARK: Lifecycle Functions
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.nextViewButton = UIButton(type: UIButtonType.Custom)
        self.nextViewButton?.setTitle("NextVC", forState: UIControlState.Normal)
        self.nextViewButton?.addTarget(self, action: #selector(FMViewControler.nextVCPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.nextViewButton?.frame = CGRectMake(0, 0, 100, 100)
        self.view.addSubview(self.nextViewButton!)
        
    }
    
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func nextVCPressed(sender: UIButton) {
        //self.performSegueWithIdentifier("toNext", sender: self)
        print("Next Pressed")
    }
    
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.performSegueWithIdentifier("toMap", sender: self)
    }
    //MARK: Container Functions
    
    public override func addChildViewController(childController: UIViewController) {
        
        
    }
    
    
    public override func removeFromParentViewController() {
        
        
    }
    
    
    public override func willMoveToParentViewController(parent: UIViewController?) {
        
        
        
    }
    
    public override func didMoveToParentViewController(parent: UIViewController?) {
        
        
        
        
    }
    
    
    //MARK: Transitioning Delegate Functions
    public func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return nil
    }
    
    
    public func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return nil
    }
    
    
    public func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return nil
    }
    
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    //MARK:
}




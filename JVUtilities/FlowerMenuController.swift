//
//  FlowerMenuController.swift
//  JVUtilities
//
//  Created by Jon Vogel on 4/16/16.
//  Copyright © 2016 Jon Vogel. All rights reserved.
//

import UIKit

@objc
public protocol PedalProtocol {
    var pedalImage: UIImage? { get set }
    var pedalName: String? { get set }
}


//Make a Container View Controller
//https://developer.apple.com/library/ios/featuredarticles/ViewControllerPGforiPhoneOS/ImplementingaContainerViewController.html

public class FMViewControler: UIViewController, UIViewControllerTransitioningDelegate, FlowerMenuDelegate {
    
    //MARK: Properties
    
    public private(set) var flowerMenu: FlowerMenu!
    public var viewControllers = [UIViewController]()
    public var pedalImages = [UIImage]()
    public var pedalNames = [String]()
    
    //MARK: Lifecycle Functions
    public override func viewDidLoad() {
        super.viewDidLoad()
        

    
    }
    
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: Custom Functions
    
    public func addViewController(viewController: UIViewController, withPedalImage image: UIImage, withPedalTitle title: String){
        if self.flowerMenu == nil {
            guard let menuImage = UIImage(named: "MenuIconGood") else {
                return
            }
            
            self.flowerMenu = FlowerMenu(withPosition: .UpperRight, andSuperView: self.view, andImage: menuImage)
            self.flowerMenu.showPedalLabels = true
            self.flowerMenu.delegate = self
        }
        
        self.viewControllers.append(viewController)
        self.pedalImages.append(image)
        self.pedalNames.append(title)
        self.flowerMenu.addPedal(image, identifier: title)
        if self.viewControllers.count == 1 {
            self.addChildViewController(self.viewControllers[0])

        }
    }
    
    //MARK: Flower Menu Delegate Functions
    public func flowerMenuDidSelectPedalWithID(theMenu: FlowerMenu, identifier: String, pedal: UIView){
        
        print("Touched pedal named: " + identifier )
        
        guard let oneController = self.childViewControllers.first else {
            return
        }
        
        oneController.willMoveToParentViewController(nil)
        
        oneController.view.removeFromSuperview()
        
        oneController.removeFromParentViewController()
        
        for (index, title) in self.pedalNames.enumerate() {
            if title == identifier {
                self.addChildViewController(self.viewControllers[index])
            }
        }
        
        self.flowerMenu.shrivel()
        
    }
    public func flowerMenuDidExpand(){
        print("Flower Menu Expended")
    }
    public func flowerMenuDidRetract(){
        print("Flower Menu Collapsed")
    }
    
    
    //MARK: Container Functions
    public override func addChildViewController(childController: UIViewController) {
        
        super.addChildViewController(childController)
        print("Add Child View Called")
        
        childController.view.frame = self.view.frame
        
        self.view.insertSubview(childController.view, atIndex: 0)
        
        childController.didMoveToParentViewController(self)
        
    }
    
    public override func removeFromParentViewController() {
        
        print("Remove From Parent View")
    }
    
    
    public override func willMoveToParentViewController(parent: UIViewController?) {
        print("Will Move To Parent View")
        
        
    }
    
    public override func didMoveToParentViewController(parent: UIViewController?) {
        
        print("Did Move To Parent View")
        
        
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




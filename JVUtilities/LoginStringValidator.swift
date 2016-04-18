//
//  LoginStringValidator.swift
//  JVUtilities
//
//  Created by Jon Vogel on 4/5/16.
//  Copyright © 2016 Jon Vogel. All rights reserved.
//

import Foundation


public class LoginStringValidator {
    
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    
    //let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$"
    
    let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$"
    
    var emailPredicate: NSPredicate!
    
    var passwordPredicate: NSPredicate!
    
    public init() {
        self.emailPredicate = NSPredicate(format: "SELF MATCHES %@", self.emailRegex)
        self.passwordPredicate = NSPredicate(format: "SELF MATCHES %@", self.passwordRegex)
    }
    
    public func validateEmail(theEmail: String) -> Bool {
        let finalEmail = theEmail.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if finalEmail.isEmpty == true {
            return false
        }else{
            return self.emailPredicate.evaluateWithObject(theEmail)
        }
    }
    
    public func validatePassword(thePassword: String) -> Bool {
        let finalPassword = thePassword.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if finalPassword.isEmpty == true {
            return false
        }else{
            return self.passwordPredicate.evaluateWithObject(thePassword)
        }
    }
    
    public func badLogin(views: [UIView], reasonLabel: UILabel?, reason: String?) {
        
        if reasonLabel != nil && reason != nil {
            reasonLabel?.text = reason!
        }
        
        let colorAnimation = CABasicAnimation(keyPath: "borderColor")
        colorAnimation.fromValue = UIColor(red: 168/255, green: 17/255, blue: 0/255, alpha: 1.0).CGColor
        colorAnimation.toValue = UIColor.blackColor().CGColor
        let widthAnimation = CABasicAnimation(keyPath: "borderWidth")
        widthAnimation.fromValue = 3.0
        widthAnimation.toValue = 0.0
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 5.0
        animationGroup.animations = [colorAnimation, widthAnimation]
        animationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animationGroup.delegate = self
        animationGroup.removedOnCompletion = true
        for view in views {
            view.layer.cornerRadius = 5
            view.layer.addAnimation(animationGroup, forKey: "colorAnimation and widthAnimation")
        }
    }


}

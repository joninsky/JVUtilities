//
//  NotificationManager.swift
//  JVUtilities
//
//  Created by Jon Vogel on 4/5/16.
//  Copyright © 2016 Jon Vogel. All rights reserved.
//

//
//  NotificationManager.swift
//  HoneyTestApp
//
//  Created by Jon Vogel on 4/1/16.
//  Copyright © 2016 Jon Vogel. All rights reserved.
//

import UIKit

private let debugKey = "Debug"
private let screenKey = "ScreenNotifications"

public protocol NewNotificationDelegate {
    func gotNewNotification(theNotification: Notification)
}

public class NotificaitonManager {
    //MARK: Shared instance
    public class var sharedInstance: NotificaitonManager {
        struct Static{
            static let instance: NotificaitonManager = NotificaitonManager()
        }
        return Static.instance
    }
    
    //MARK: Properties
    //Make A Notification Archiver
    let notificationArchiver = NotificationArchiver()
    //Notificaiton Delegate
    public var notificationDelegate: NewNotificationDelegate?
    //Array Of notifications
    public var notifications = [Notification]()
    //View that can get badged when notificaitons are sent
    public var viewToBadge: AnyObject? {
        didSet{
            if self.badgeView == nil {
                //self.badgeView = Badger(badgeColor: nil, textColor: nil, viewToBadge: self.viewToBadge!, initialValue: "")
            }
        }
    }
    //View that represents the badge on a view that does not already have a badge built in
    private var badgeView: Badger?
    //Variable to determine if we should fire debug notifications or not
    public var fireDebugNotifications = NSUserDefaults.standardUserDefaults().boolForKey(debugKey) {
        didSet {
            NSUserDefaults.standardUserDefaults().setBool(self.fireDebugNotifications, forKey: debugKey)
        }
    }
    //Variable to determine if we should fire screened notifications or not
    public var fireScreenedNotifications = NSUserDefaults.standardUserDefaults().boolForKey(screenKey) {
        didSet{
            NSUserDefaults.standardUserDefaults().setObject(self.fireScreenedNotifications, forKey: screenKey)
        }
    }
    
    
    //MARK: Init
    
    init(){

        self.notifications = notificationArchiver.getNotifications()
        
    }
    
    //MARK: Functions
    public func fireNotification(theNotification: Notification) {
        
        if self.fireDebugNotifications == false && theNotification.debug == true {
            return
        }
        
        if self.fireScreenedNotifications == false && theNotification.screenedNotification == true {
            return
        }
        
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        
        self.refreshTabBarItem()
        
        let notification = UILocalNotification()
        notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber
        notification.alertTitle = theNotification.text
        if theNotification.text != nil && theNotification.expandedText != nil {
            notification.alertBody = theNotification.text! + " - " + theNotification.expandedText!
        }else{
            notification.alertBody = theNotification.expandedText
        }
        notification.userInfo = theNotification.info
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        
        self.notificationArchiver.saveNotification(theNotification)
        self.notifications.insert(theNotification, atIndex: 0)
        self.notificationDelegate?.gotNewNotification(theNotification)
    }
    
    public func popUpNotification(title: String, message: String?, viewThatWillPresentAlert view: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        alertController.addAction(okAction)
        
        view.presentViewController(alertController, animated: true, completion: nil)
    }
    
    public func refreshTabBarItem() {
        if UIApplication.sharedApplication().applicationIconBadgeNumber == 0 {
            
            switch self.viewToBadge {
            case is UITabBarItem:
                guard let tabBar = self.viewToBadge as? UITabBarItem else{
                    return
                }
                
                tabBar.badgeValue = ""
            case is UIView:
//                guard let view = self.viewToBadge as? UIView else{
//                    return
//                }
                print("Is UIView")
            default:
                return
            }
            
            
            if self.viewToBadge is UITabBarItem {

            }

        }else{
            
            if self.viewToBadge is UITabBarItem {
                guard let tabBar = self.viewToBadge as? UITabBarItem else{
                    return
                }
                
                tabBar.badgeValue = "\(UIApplication.sharedApplication().applicationIconBadgeNumber)"
            }

        }
        
    }
    
    public func deleteAllNotifications() {
        self.notifications = self.notificationArchiver.removeAllNotifications()
    }
    
    
    
    //MARK: End Class
}

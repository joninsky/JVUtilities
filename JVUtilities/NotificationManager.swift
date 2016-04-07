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

let debugKey = "Debug"

public protocol NewNotificationDelegate {
    func gotNewNotification(theNotification: Notification)
}

public class NotificaitonManager {
    //MARK: Shared instance
    internal class var sharedInstance: NotificaitonManager {
        struct Static{
            static let instance: NotificaitonManager = NotificaitonManager()
        }
        return Static.instance
    }
    
    //MARK: Properties
    
    let notificationArchiver = NotificationArchiver()
    
    var notificationDelegate: NewNotificationDelegate?
    
    public var notifications = [Notification]()
    
    public var tabBarItemToUpdate: UITabBarItem?
    
    //MARK: Init
    
    init(){
        
        self.notifications = notificationArchiver.getNotifications()
        
    }
    
    //MARK: Functions
    public func fireNotification(theNotification: Notification) {
        
        if NSUserDefaults.standardUserDefaults().boolForKey(debugKey) == false && theNotification.debug == true {
            return
        }
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        
        self.refreshTabBarItem()
        
        let notification = UILocalNotification()
        notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber
        notification.alertTitle = theNotification.text
        notification.alertBody = theNotification.expandedText
        notification.userInfo = theNotification.info
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        
        self.notificationArchiver.saveNotification(theNotification)
        self.notifications.insert(theNotification, atIndex: 0)
        self.notificationDelegate?.gotNewNotification(theNotification)
    }
    
    public func refreshTabBarItem() {
        if UIApplication.sharedApplication().applicationIconBadgeNumber == 0 {
            self.tabBarItemToUpdate?.badgeValue = nil
        }else{
            self.tabBarItemToUpdate?.badgeValue = "\(UIApplication.sharedApplication().applicationIconBadgeNumber)"
        }
        
    }
    
    public func deleteAllNotifications() {
        self.notifications = self.notificationArchiver.removeAllNotifications()
    }
    
    
    
    //MARK: End Class
}

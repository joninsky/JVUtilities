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
//Global constants for user defaults
internal let debugKey = "Debug"
internal let screenKey = "ScreenNotifications"

//Protocol for alerting different parts of the app about a new notification.
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
    //Array of Tuples that keep a bagde view associated with a view that the uset wants badged. The user adds a new view that they wan badged throug the addViewToBadgeFunction.
    private var viewsToBadge: [(aView: UIView, aBadger: Badger)] = [(aView: UIView, aBadger: Badger)]()
    //Array of tab bars that the user wants badged
    public var tabBarsToBadge: [UITabBarItem] = [UITabBarItem]()
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
        //Get all notifications from disk
        self.notifications = notificationArchiver.getNotifications()
    }
    
    //MARK: Functions
    //This function lets the user add a view that they want to be badged as app level notifications come through.
    public func addViewToBadge(theView: UIView) {
        //Create a new badger for the view and give it the default colors and pin it to the view the user pased in
        let newBadger = Badger(badgeColor: nil, textColor: nil, viewToBadge: theView, initialValue: "\(UIApplication.sharedApplication().applicationIconBadgeNumber)")
        //Append a newly created tuple to the array of views to badge
        self.viewsToBadge.append((theView, newBadger))
    }
    
    //This is the file notification function
    public func fireNotification(theNotification: Notification) {
        //This determines if we should fire this notification based on the debug flag
        if self.fireDebugNotifications == false && theNotification.debug == true {
            return
        }
        //This determines if we should fire the notificaiton based on the screened Notificaiton flag
        if self.fireScreenedNotifications == false && theNotification.screenedNotification == true {
            return
        }
        //This increments the applicaiton icon badge number
        UIApplication.sharedApplication().applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        //Call the method that refreses all the views that the user has said wants to know about applicaiton badge numbers
        self.refreshTabBarItem()
        //Create the system notificaton
        let notification = UILocalNotification()
        //Give it the notificaiton a badge number
        notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber
        //Set the title to the notificaiton text
        notification.alertTitle = theNotification.text
        //COnstruct the alert body
        if theNotification.text != nil && theNotification.expandedText != nil {
            notification.alertBody = theNotification.text! + " - " + theNotification.expandedText!
        }else{
            notification.alertBody = theNotification.expandedText
        }
        //Set the user info
        notification.userInfo = theNotification.info
        //Present local notificaiton
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        //Save the notificaiton to disk
        self.notificationArchiver.saveNotification(theNotification)
        //INsert the notificaiton into the managers array of notificaitons
        self.notifications.insert(theNotification, atIndex: 0)
        //Alert the notification delegate that we fired a new notification
        self.notificationDelegate?.gotNewNotification(theNotification)
    }
    
    
    //Convenience method for a pop up notification
    public func popUpNotification(title: String, message: String?, viewThatWillPresentAlert view: UIViewController) {
        //Create the alertController
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        //Create the OK Action
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        //Add the action to the controller
        alertController.addAction(okAction)
        //Present the alert controller
        view.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    //Function to keep the badges on view synced to the application badge number
    public func refreshTabBarItem() {
        //See if the application badge number is zero
        if UIApplication.sharedApplication().applicationIconBadgeNumber == 0 {
            //If it is enumerate throught the view to badge
            for (index, item) in self.viewsToBadge.enumerate() {
                //Set the badger view to ""
                item.aBadger.badgeValue = ""
            }
            //Loop through the tab bars to badge
            for item in self.tabBarsToBadge {
                //Set the value to nil
                item.badgeValue = nil
            }
        }else{
            //Do the same except set the value to the application badge number
            for (index,item) in self.viewsToBadge.enumerate() {
                item.aBadger.badgeValue = "\(UIApplication.sharedApplication().applicationIconBadgeNumber)"
            }
            for item in self.tabBarsToBadge {
                item.badgeValue = "\(UIApplication.sharedApplication().applicationIconBadgeNumber)"
            }
        }
    }
    
    
    //Delete all notificaitons
    public func deleteAllNotifications() {
        self.notifications = self.notificationArchiver.removeAllNotifications()
    }
    
    
    
    //MARK: End Class
}

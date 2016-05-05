//
//  NotificationArchiver.swift
//  JVUtilities
//
//  Created by Jon Vogel on 4/5/16.
//  Copyright © 2016 Jon Vogel. All rights reserved.
//

import Foundation


internal class NotificationArchiver: NSObject {
    //MARK: Properties
    private let pathToNotificationFile = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first!.stringByAppendingString("/NotificationFile.plist")
    //File Manager object to help us determine the state of the above file path
    private let fileChecker = NSFileManager.defaultManager()
    
    //MARK: Init
    override init() {
        super.init()
        self.makeSureFilePathsExist()
    }
    
    private func makeSureFilePathsExist(){
        if fileChecker.fileExistsAtPath(self.pathToNotificationFile) == false {
            print("Creating notification file")
            fileChecker.createFileAtPath(self.pathToNotificationFile, contents: nil, attributes: nil)
        }
    }
    
    //MARK: Notification Archive Functions
    internal func saveNotification(theNotification: Notification) {
        
        var allOfThemSuckas = self.getNotifications()
        
        //allOfThemSuckas.append(theNotification)
        
        allOfThemSuckas.insert(theNotification, atIndex: 0)
        
        if allOfThemSuckas.count > 10 {
            allOfThemSuckas.removeLast()
        }
        
        NSKeyedArchiver.archiveRootObject(allOfThemSuckas, toFile: self.pathToNotificationFile)
    }
    
    internal func getNotifications() -> [Notification] {
        guard let allNotifications = NSKeyedUnarchiver.unarchiveObjectWithFile(self.pathToNotificationFile) as? [Notification] else {
            return [Notification]()
        }
        return allNotifications
    }
    
    internal func removeAllNotifications() -> [Notification] {
        NSKeyedArchiver.archiveRootObject([Notification](), toFile: self.pathToNotificationFile)
        return [Notification]()
    }
    
    
}


//
//  Notification.swift
//  JVUtilities
//
//  Created by Jon Vogel on 4/5/16.
//  Copyright © 2016 Jon Vogel. All rights reserved.
//

import UIKit


public class Notification: NSObject, NSCoding {
    
    public var photo: UIImage?
    public var text: String?
    public var expandedText: String?
    public private(set)var date: NSDate!
    public var subPhoto: Int?
    public var seen: Bool!
    public var debug: Bool!
    public var screenedNotification: Bool!
    public var info: [String: String]?
    
    public override init() {
        super.init()
        
        self.date = NSDate()
        self.seen = false
        self.debug = false
        self.screenedNotification = false
    }
    
    //MARK: NSCoding Compliance
    public required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        if let retrievedPhoto = aDecoder.decodeObjectForKey("Photo") as? UIImage {
            self.photo = retrievedPhoto
        }
        
        if let retrievedText = aDecoder.decodeObjectForKey("Text") as? String {
            self.text = retrievedText
        }
        if let retrievedExpandedText = aDecoder.decodeObjectForKey("ExpandedText") as? String {
            self.expandedText = retrievedExpandedText
        }
        if let retrievedDate = aDecoder.decodeObjectForKey("Date") as? NSDate {
            self.date = retrievedDate
        }
        
        self.subPhoto = aDecoder.decodeIntegerForKey("SubPhoto")
        
        self.seen = aDecoder.decodeBoolForKey("seen")
        
        self.debug = aDecoder.decodeBoolForKey("debug")
        
        self.screenedNotification = aDecoder.decodeBoolForKey("Screened")
        
        if let retrievedInfo = aDecoder.decodeObjectForKey("Info") as? [String:String] {
            self.info = retrievedInfo
        }
        
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.photo, forKey: "Photo")
        aCoder.encodeObject(self.text, forKey: "Text")
        aCoder.encodeObject(self.expandedText, forKey: "ExpandedText")
        aCoder.encodeObject(self.date, forKey: "Date")
        if self.subPhoto != nil {
            aCoder.encodeInteger(self.subPhoto!, forKey: "SubPhoto")
        }
        aCoder.encodeBool(self.seen, forKey: "seen")
        aCoder.encodeBool(self.debug, forKey: "debug")
        aCoder.encodeBool(self.screenedNotification, forKey: "Screened")
        aCoder.encodeObject(self.info, forKey: "Info")
    }
}

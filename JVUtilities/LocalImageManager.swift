//
//  LocalImageManager.swift
//  JVUtilities
//
//  Created by Jon Vogel on 5/4/16.
//  Copyright © 2016 Jon Vogel. All rights reserved.
//

import UIKit


public enum ImageType: String {
    case PNG = "png"
    case JPEG = "jpeg"
}

public class ImageManager {
    //MARK: Properties
    
    let fileManager = NSFileManager.defaultManager()
    
    
    //MARK: Inti
    public init(){
        
    }
    
    public func writeImageToFile(fileName: String, fileExtension: ImageType, imageToWrite: UIImage, completion: (fileURL: NSURL?) -> Void){
        let file = fileName + "Image." + fileExtension.rawValue
        let subFolder = fileName + "Image"
        var imageData: NSData!
        
        switch fileExtension {
        case .PNG:
            guard let data = UIImagePNGRepresentation(imageToWrite) else {
                completion(fileURL: nil)
                return
            }
            imageData = data
        case .JPEG:
            guard let data = UIImageJPEGRepresentation(imageToWrite, 0.8) else {
                completion(fileURL: nil)
                return
            }
            imageData = data
        }
        

        
        var documentsURL: NSURL!
        
        do {
            documentsURL = try self.fileManager.URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false)
        }catch {
            completion(fileURL: nil)
            return
        }
        
        let folderURL = documentsURL.URLByAppendingPathComponent(subFolder)
        
        let fileURL = folderURL.URLByAppendingPathComponent(file)
        
        //if fileURL.checkPromisedItemIsReachableAndReturnError(nil) == true {
        do {
            try self.fileManager.createDirectoryAtURL(folderURL, withIntermediateDirectories: true, attributes: nil)
        }catch{
            completion(fileURL: nil)
            return
        }
        
        do {
            try imageData.writeToURL(fileURL, options: NSDataWritingOptions.AtomicWrite)
            completion(fileURL: fileURL)
        }catch {
            completion(fileURL: nil)
        }
        // }else{
        //    completion(fileURL: nil)
        //}
    }
    
    public func getImageFromFile(fileName: String, fileExtension: ImageType, completion:(theImage: UIImage?) -> Void) {
        let file = fileName + "Image." + fileExtension.rawValue
        let subFolder = fileName + "Image"
        
        var documentsURL: NSURL!
        
        do {
            documentsURL = try self.fileManager.URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false)
        }catch {
            completion(theImage: nil)
            return
        }
        
        let folderURL = documentsURL.URLByAppendingPathComponent(subFolder)
        
        let fileURL = folderURL.URLByAppendingPathComponent(file)
        
        guard let imageData = NSData(contentsOfURL: fileURL) else {
            completion(theImage: nil)
            return
        }
        
        guard let image = UIImage(data: imageData) else {
            completion(theImage: nil)
            return
        }
        
        completion(theImage: image)
        
    }
    
    
    public func getImageDataFromFile(fileName: String, fileExtension: ImageType) -> NSData?{
        let file = fileName + "Image." + fileExtension.rawValue
        let subFolder = fileName + "Image"
        
        var documentsURL: NSURL!
        
        do {
            documentsURL = try self.fileManager.URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false)
        }catch {
            return nil
        }
        
        let folderURL = documentsURL.URLByAppendingPathComponent(subFolder)
        
        let fileURL = folderURL.URLByAppendingPathComponent(file)
        
        guard let imageData = NSData(contentsOfURL: fileURL) else {
            return nil
        }
        
        return imageData
    }
    
    public func generateFolderForDownload(fileName: String, fileExtension: String) -> NSURL? {
        let file = fileName + "Image." + fileExtension
        let subFolder = fileName + "Image"
        
        var documentsURL: NSURL!
        
        do {
            documentsURL = try self.fileManager.URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false)
        }catch {
            return nil
        }
        
        let folderURL = documentsURL.URLByAppendingPathComponent(subFolder)
        
        let fileURL = folderURL.URLByAppendingPathComponent(file)
        
        return fileURL
    }
    
    
    public func removeImageAtURL(fileName: String, fileExtension: String, completion: (didComplete: Bool) -> Void) {
        let file = fileName + "Image." + fileExtension
        let subFolder = fileName + "Image"
        
        var documentsURL: NSURL!
        
        do {
            documentsURL = try self.fileManager.URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false)
        }catch {
            completion(didComplete: false)
            return
        }
        
        let folderURL = documentsURL.URLByAppendingPathComponent(subFolder)
        
        let fileURL = folderURL.URLByAppendingPathComponent(file)
        
        if fileURL.checkPromisedItemIsReachableAndReturnError(nil) == true {
            do {
                try self.fileManager.removeItemAtURL(fileURL)
            }catch{
                completion(didComplete: false)
                return
            }
            
        }else{
            completion(didComplete: false)
        }
    }
    
    
    //MARK: End Class
}

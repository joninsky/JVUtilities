//
//  LocalImageManager.swift
//  JVUtilities
//
//  Created by Jon Vogel on 5/4/16.
//  Copyright © 2016 Jon Vogel. All rights reserved.
//

import UIKit

public class LocalImageManager {
    //MARK: Properties
    
    let fileManager = NSFileManager.defaultManager()
    
    
    //MARK: Inti
    init(){
        
    }
    
    public func writeImageToFile(fileName: String, fileExtension: String, imageToWrite: UIImage, completion: (fileURL: NSURL?) -> Void){
        let file = fileName + "Image." + fileExtension
        let subFolder = fileName + "Image"
        
        guard let imageData = UIImagePNGRepresentation(imageToWrite) else {
            completion(fileURL: nil)
            return
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
        
        if fileURL.checkPromisedItemIsReachableAndReturnError(nil) == true {
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
        }else{
            completion(fileURL: nil)
        }
    }
    
    public func getImageFromFile(fileName: String, fileExtension: String, completion:(theImage: UIImage?) -> Void) {
        let file = fileName + "Image." + fileExtension
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

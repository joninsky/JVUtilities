//
//  TUView.swift
//  JVUtilities
//
//  Created by Jon Vogel on 4/7/16.
//  Copyright © 2016 Jon Vogel. All rights reserved.
//

import UIKit

public class TUView: UICollectionViewController {
    
    //Properties
    var pagingControl: UIPageControl?
    
    var viewDictionary: [String:UIView]?
    
    var arrayOfImages: [UIImage] = [UIImage]()
    
    var flowLayout: UICollectionViewFlowLayout?
    
    var currentIndex: NSIndexPath?
    
    var dismissGesture: UITapGestureRecognizer?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        //Instantiate the paging view
        self.pagingControl = UIPageControl()
        self.pagingControl?.numberOfPages = self.arrayOfImages.count
        
        //Turn off translates masks for everything paging control
        self.pagingControl!.translatesAutoresizingMaskIntoConstraints = false
        
        //Set Flow layout Scroll direction
        self.flowLayout!.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        //Configure the Collection VIew
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: self.flowLayout!)
        self.collectionView!.registerClass(TUCell.self, forCellWithReuseIdentifier: "tutorialCell")
        self.collectionView!.pagingEnabled = true
        self.view.addSubview(self.pagingControl!)
        //self.view.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView!.backgroundColor = UIColor.whiteColor()
        
        //Create the dictionary that hold sthe views for autolayout
        self.viewDictionary = ["me":self.collectionView!, "pagingControl":self.pagingControl!]
        self.setUpRelativeToView(self.collectionView!, otherViews: self.viewDictionary!)
        
        //Subscribe to interface Change Notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TUView.orientationChanged(_:)), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        //Set up gesture recognizer to dismiss the controller
        self.dismissGesture = UITapGestureRecognizer(target: self, action: #selector(TUView.dismiss(_:)))
        self.dismissGesture?.numberOfTapsRequired = 2
        self.collectionView!.addGestureRecognizer(self.dismissGesture!)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
    }
    
    public init(arrayOfImages: [UIImage]) {
        
        self.flowLayout = UICollectionViewFlowLayout()
        
        super.init(collectionViewLayout: flowLayout!)
        
        self.arrayOfImages = arrayOfImages
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Public functions
    
    func setPagingControlColor(currentPageColor: UIColor, notCurrentPageColor: UIColor) {
        self.pagingControl?.currentPageIndicatorTintColor = currentPageColor
        self.pagingControl?.pageIndicatorTintColor = notCurrentPageColor
    }
    
    
    //Collection View Functions
    public override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        self.currentIndex = NSIndexPath(forRow: 0, inSection: 0)
        
        return self.arrayOfImages.count
        
    }
    
    public func dismiss(gesture: UITapGestureRecognizer) {
        
        self.dismissViewControllerAnimated(true) { () -> Void in
            
            
        }
        
    }
    
    
    public override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let Cell = collectionView.dequeueReusableCellWithReuseIdentifier("tutorialCell", forIndexPath: indexPath) as! TUCell
        
        Cell.cellImage.image = self.arrayOfImages[indexPath.row]
        
        Cell.backgroundColor = UIColor.whiteColor()
        
        return Cell
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
        return self.returnDesiredCellSize()
        
    }
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    
    
    public override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        
        let visibleRect = CGRect(origin: self.collectionView!.contentOffset, size: self.collectionView!.bounds.size)
        
        let thePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMinY(visibleRect))
        
        if let index = self.collectionView!.indexPathForItemAtPoint(thePoint) {
            self.currentIndex = index
            
            self.pagingControl?.currentPage = index.row
        }
    }
    
    
    public override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if self.currentIndex?.row == self.arrayOfImages.count - 1 {
            
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
                
            })
        }
    }
    
    
    func orientationChanged(notification: NSNotification) {
        
        self.collectionView?.collectionViewLayout.invalidateLayout()
        
    }
    
    
    //Auto Layout Functions
    func setUpRelativeToView(theView: UIView, otherViews: [String:UIView]) {
        
        var arrayOfConstraints = [NSLayoutConstraint]()
        
        let pagingViewHorizontalConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.pagingControl!, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        
        arrayOfConstraints.append(pagingViewHorizontalConstraint)
        
        
        let pagingViewVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[pagingControl]-30-|", options: [], metrics: nil, views: otherViews)
        
        for c in pagingViewVerticalConstraints {
            arrayOfConstraints.append(c)
        }
        
        self.view.addConstraints(arrayOfConstraints)
        
        
    }
    
    private func returnDesiredCellSize() -> CGSize {
        
        if let index = self.currentIndex {
            
            let anImage = self.arrayOfImages[index.row]
            
            if anImage.size.height > self.collectionView!.frame.height || anImage.size.width > self.collectionView!.frame.width{
                
                let aspectRatio = anImage.size.width / anImage.size.height
                
                
                if anImage.size.height > self.collectionView!.frame.height {
                    let adjustedForLargerHeight = CGSizeMake(self.collectionView!.frame.height * aspectRatio, self.collectionView!.frame.height)
                    return adjustedForLargerHeight
                }else {
                    let adjustedForLargerWidth = CGSizeMake(self.collectionView!.frame.width, self.collectionView!.frame.width * aspectRatio)
                    return adjustedForLargerWidth
                }
                
            }else{
                return CGSizeMake(self.collectionView!.frame.width, self.collectionView!.frame.height)
                //return CGSizeMake(anImage.size.width, anImage.size.height)
            }
            
        }else{
            print(CGSizeMake(self.collectionView!.frame.width, self.collectionView!.frame.height))
            return CGSizeMake(self.collectionView!.frame.width, self.collectionView!.frame.height)
        }
    }
    
    
    //End Class
}



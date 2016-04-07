//
//  TUCell.swift
//  JVUtilities
//
//  Created by Jon Vogel on 4/7/16.
//  Copyright © 2016 Jon Vogel. All rights reserved.
//

import UIKit

public class TUCell: UICollectionViewCell {
    
    
    
    var cellImage: UIImageView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.translatesAutoresizingMaskIntoConstraints = false
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        self.cellImage.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.addSubview(self.cellImage)
        
        self.constrainImageView()
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constrainImageView() {
        
        var constraints = [NSLayoutConstraint]()
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(>=0)-[image]-(>=0)-|", options: [], metrics: nil, views: ["image":self.cellImage])
        
        for c in verticalConstraints {
            constraints.append(c)
        }
        
        let centerHorizontal = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.cellImage, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        
        constraints.append(centerHorizontal)
        
        let centerVertical = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.cellImage, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        
        constraints.append(centerVertical)
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(>=0)-[image]-(>=0)-|", options: [], metrics: nil, views: ["image":self.cellImage])
        
        for c in horizontalConstraints {
            constraints.append(c)
        }
        
        self.addConstraints(constraints)
        
    }
    
    
}



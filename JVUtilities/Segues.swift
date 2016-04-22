//
//  Segues.swift
//  JVUtilities
//
//  Created by Jon Vogel on 4/16/16.
//  Copyright © 2016 Jon Vogel. All rights reserved.
//

import Foundation

//MARK: Segues
@objc(Pedal) public class Pedal: UIStoryboardSegue {
    public override func perform() {
        guard let src = self.sourceViewController as? FMViewControler else {
            return
        }
        let dest = self.destinationViewController
        src.showViewController(dest, sender: self)
    }
}
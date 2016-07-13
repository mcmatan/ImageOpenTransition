//
//  imageExnetions.swift
//  CellOpenTransition
//
//  Created by Matan Cohen on 7/13/16.
//  Copyright © 2016 Jive. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func copyMe()->UIImage {
        let newCgIm = CGImageCreateCopy(self.CGImage)
        let newImage = UIImage(CGImage: newCgIm!, scale: self.scale, orientation: self.imageOrientation)
        return newImage
    }
}
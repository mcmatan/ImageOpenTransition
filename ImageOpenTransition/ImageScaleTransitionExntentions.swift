//
//  ImageScaleTransitionUtils.swift
//  ImageOpenTransition
//
//  Created by Matan Cohen on 7/17/16.
//  Copyright © 2016 Jive. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func heightOfNavigationControllerAndStatusAtViewController()-> CGFloat {
        var height : CGFloat = 0
        if let isNavigationController = self.navigationController {
            height += isNavigationController.navigationBar.frame.height;
        }

        
        if UIApplication.shared.isStatusBarHidden == false {
            height += UIApplication.shared.statusBarFrame.height
        }

        
        return height
    }
}

extension UIImage {
    
    func copyMe()->UIImage {
        let newCgIm = self.cgImage!.copy()
        let newImage = UIImage(cgImage: newCgIm!, scale: self.scale, orientation: self.imageOrientation)
        return newImage
    }
}

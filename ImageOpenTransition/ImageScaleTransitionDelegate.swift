//
//  ImageOpenTransition.swift
//  CellOpenTransition
//
//  Created by Matan Cohen on 7/12/16.
//  Copyright © 2016 Jive. All rights reserved.
//

import Foundation
import UIKit

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////


 * ImageScaleTransitionObjects should be inserted in an array, first is lowest as subview, and the last object will be the top subview
 
 * UIImageView - view to translate from, has to be:
  imageView.contentMode = UIViewContentMode.ScaleAspectFill
  imageView.clipsToBounds = true



////////////////////////////////////////////////////////////////////////////////////////////////////////
 */

class ImageScaleTransitionDelegate : NSObject , UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    var transitionObjects : Array<ImageScaleTransitionObject>!
    var usingNavigationController : Bool
    
    init(transitionObjects : Array<ImageScaleTransitionObject>, usingNavigationController : Bool) {
        self.transitionObjects = transitionObjects
        self.usingNavigationController = usingNavigationController
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let presentAnimation = ImageScaleTransitionPresent(transitionObjects: self.transitionObjects)
        return presentAnimation
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let dismissAnimation = ImageScaleTransitionDismiss(transitionObjects: self.transitionObjects, usingNavigationController: self.usingNavigationController)
        return dismissAnimation
    }
    
    //MARK: Navigation controller transition
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .Pop:
            let dismissAnimation = ImageScaleTransitionDismiss(transitionObjects: self.transitionObjects, usingNavigationController: self.usingNavigationController)
            return dismissAnimation
        case .Push:
            let presentAnimation = ImageScaleTransitionPresent(transitionObjects: self.transitionObjects)
            return presentAnimation
        case .None:
            return nil
        }
    }
}
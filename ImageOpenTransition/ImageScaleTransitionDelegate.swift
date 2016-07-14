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

public class ImageScaleTransitionDelegate : NSObject , UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    var transitionObjects : Array<ImageScaleTransitionObject>!
    var usingNavigationController : Bool
    var duration: NSTimeInterval
    
    public init(transitionObjects : Array<ImageScaleTransitionObject>, usingNavigationController : Bool, duration: NSTimeInterval) {
        self.transitionObjects = transitionObjects
        self.usingNavigationController = usingNavigationController
        self.duration = duration
    }
    
    public final func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let presentAnimation = ImageScaleTransitionPresent(transitionObjects: self.transitionObjects, duration : duration)
        return presentAnimation
    }
    
    public final func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let dismissAnimation = ImageScaleTransitionDismiss(transitionObjects: self.transitionObjects, usingNavigationController: self.usingNavigationController, duration : duration)
        return dismissAnimation
    }
    
    //MARK: Navigation controller transition
    public final func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .Pop:
            let dismissAnimation = ImageScaleTransitionDismiss(transitionObjects: self.transitionObjects, usingNavigationController: self.usingNavigationController, duration : duration)
            return dismissAnimation
        case .Push:
            let presentAnimation = ImageScaleTransitionPresent(transitionObjects: self.transitionObjects, duration : duration)
            return presentAnimation
        case .None:
            return nil
        }
    }
}
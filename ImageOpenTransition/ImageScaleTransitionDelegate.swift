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
    var fadeOutAnimationDuration = 0.3 //After animation happends, this is the fade out of the image copy.
    
    public init(transitionObjects : Array<ImageScaleTransitionObject>, usingNavigationController : Bool, duration: NSTimeInterval) {
        self.transitionObjects = transitionObjects
        self.usingNavigationController = usingNavigationController
        self.duration = duration
    }
    
    public final func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.createImageScaleTransitionPresent()
    }
    
    public final func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.createImageScaleTransitionDismiss()
    }
    
    //MARK: Navigation controller transition
    public final func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .Pop:
            return self.createImageScaleTransitionDismiss()
        case .Push:
            return self.createImageScaleTransitionPresent()
        case .None:
            return nil
        }
    }
    
    internal func createImageScaleTransitionDismiss()->ImageScaleTransitionDismiss {
        return  ImageScaleTransitionDismiss(transitionObjects: self.transitionObjects, usingNavigationController: self.usingNavigationController, duration : duration, fadeOutAnimationDuration : self.fadeOutAnimationDuration)
    }
    
    internal func createImageScaleTransitionPresent()->ImageScaleTransitionPresent {
        return ImageScaleTransitionPresent(transitionObjects: self.transitionObjects, duration : duration, fadeOutAnimationDuration : self.fadeOutAnimationDuration)
    }
}
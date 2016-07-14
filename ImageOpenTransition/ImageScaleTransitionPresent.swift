//
//  ImageScaleTransitionPresent.swift
//  CellOpenTransition
//
//  Created by Matan Cohen on 7/12/16.
//  Copyright © 2016 Jive. All rights reserved.
//

import Foundation
import UIKit

class ImageScaleTransitionPresent : NSObject , UIViewControllerAnimatedTransitioning {
    let animationOptions = UIViewAnimationOptions.CurveEaseInOut
    var duration : NSTimeInterval!
    var transitionObjects: Array<ImageScaleTransitionObject>!
    
    init(transitionObjects : Array<ImageScaleTransitionObject>, duration: NSTimeInterval) {
        self.transitionObjects  = transitionObjects
        super.init()
        self.duration = duration
    }
    
    @objc func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }
    
    @objc func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containerView = transitionContext.containerView()
        
        toViewController!.view.alpha = 0
        containerView!.addSubview((toViewController!.view)!)
        
        for transitionObject in self.transitionObjects {
            self.animateTransitionObject(transitionObject, fromViewController: fromViewController!, toViewController: toViewController!, containerView: containerView!)
        }
        
            UIView.animateWithDuration(self.duration, animations: {
                toViewController?.view.alpha = 1.0
                }, completion: { (finish) in
                      transitionContext.completeTransition(true)
            })
        
    }
    

    func animateTransitionObject(transitionObject : ImageScaleTransitionObject, fromViewController : UIViewController, toViewController : UIViewController, containerView : UIView) {
        
        transitionObject.viewToAnimateTo?.hidden = true
        transitionObject.viewToAnimateFrom.hidden = true
    
        let viewEndFrame = transitionObject.frameToAnimateTo
        
        assert(transitionObject.viewToAnimateFrom.image != nil, "Trying to animate with no Image")
        
        let viewToAnimateFromCopy = UIImageView(image: transitionObject.viewToAnimateFrom.image!.copyMe())
        viewToAnimateFromCopy.contentMode = UIViewContentMode.ScaleAspectFill
        
        
        viewToAnimateFromCopy.frame = transitionObject.viewToAnimateFrom.frame
        
        let viewStartingCenter = transitionObject.viewToAnimateFrom.superview!.convertPoint(transitionObject.viewToAnimateFrom.center, toView: containerView)
        viewToAnimateFromCopy.center = viewStartingCenter;
        
        viewToAnimateFromCopy.clipsToBounds = true
        
        let viewHasRoundedCorders = transitionObject.viewToAnimateFrom.layer.cornerRadius == transitionObject.viewToAnimateFrom.frame.size.height/2;
        let scaleSize = viewEndFrame.height/viewToAnimateFromCopy.frame.height
        if (viewHasRoundedCorders == true) {
            viewToAnimateFromCopy.layer.cornerRadius = viewToAnimateFromCopy.frame.size.height/2
        }
        
        containerView.addSubview(viewToAnimateFromCopy)
        
        UIView.animateWithDuration(transitionObject.duration, delay: 0, options: animationOptions, animations: {
            
            if viewHasRoundedCorders == true {
                viewToAnimateFromCopy.transform = CGAffineTransformMakeScale(scaleSize, scaleSize)
                viewToAnimateFromCopy.center = CGPointMake(viewEndFrame.origin.x + (viewEndFrame.width/2), viewEndFrame.origin.y + (viewEndFrame.height/2))
            } else {
                viewToAnimateFromCopy.frame = viewEndFrame
            }
        }) { (finished) in}
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(self.duration * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            transitionObject.viewToAnimateTo?.hidden = false
            transitionObject.viewToAnimateFrom?.hidden = false
            viewToAnimateFromCopy.hidden = true
            
        }
    }
    
    func maximumDuration(imageScaleObjects : Array<ImageScaleTransitionObject>)-> NSTimeInterval {
        let durations = self.transitionObjects.map {
            $0.duration
        }
        let numMax = durations.reduce(Double(0), combine: { max($0, $1) })
        return numMax
    }
}
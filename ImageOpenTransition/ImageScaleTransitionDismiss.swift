//
//  ImageScaleTransitionDismiss.swift
//  CellOpenTransition
//
//  Created by Matan Cohen on 7/12/16.
//  Copyright © 2016 Jive. All rights reserved.
//

import Foundation
import UIKit

class ImageScaleTransitionDismiss : NSObject , UIViewControllerAnimatedTransitioning {
    let animationOptions = UIViewAnimationOptions.CurveEaseInOut
    var duration : NSTimeInterval!
    var transitionObjects: Array<ImageScaleTransitionObject>!
    var usingNavigationController : Bool
    
    init(transitionObjects : Array<ImageScaleTransitionObject>, usingNavigationController : Bool) {
        self.transitionObjects  = transitionObjects
        self.usingNavigationController = usingNavigationController
        super.init()
        self.duration = self.maximumDuration(self.transitionObjects)/0.7
    }
    
    @objc func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }
    
    @objc func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containerView = transitionContext.containerView()
        self.duration = self.maximumDuration(self.transitionObjects)
        
        if self.usingNavigationController == true {
            containerView!.addSubview((toViewController!.view)!)
        }
        
        fromViewController!.view.alpha = 1
        containerView!.addSubview((fromViewController!.view)!)

        for transitionObject in self.transitionObjects {
            self.animateTransitionObject(transitionObject, fromViewController: fromViewController!, toViewController: toViewController!, containerView: containerView!)
        }
        
        UIView.animateWithDuration(self.duration, animations: {
            fromViewController?.view.alpha = 0;
            }, completion: nil)
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(self.duration * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            UIView.animateWithDuration(self.duration/2, animations: {
                toViewController?.view.alpha = 1.0
                }, completion: { (finish) in
                        transitionContext.completeTransition(true)
            })
        }
    }
    
    
    
    func animationEnded(transitionCompleted: Bool) {
        
    }
    
    func animateTransitionObject(transitionObject : ImageScaleTransitionObject, fromViewController : UIViewController, toViewController : UIViewController, containerView : UIView) {
        
        let viewEndCenter = transitionObject.viewToAnimateFrom.superview!.convertPoint(transitionObject.viewToAnimateFrom.center, toView: fromViewController.view)
        
        transitionObject.viewToAnimateTo?.hidden = true
        transitionObject.viewToAnimateFrom.hidden = true
        
        let animationDuration = transitionObject.duration
        let viewEndFrame = transitionObject.viewToAnimateFrom.frame
        
        
        let viewToAnimateFromCopy = UIImageView(image: transitionObject.viewToAnimateFrom.image!.copyMe())
        viewToAnimateFromCopy.contentMode = UIViewContentMode.ScaleAspectFill
        viewToAnimateFromCopy.clipsToBounds = true
        viewToAnimateFromCopy.frame = (transitionObject.viewToAnimateTo?.frame)!
        
        containerView.addSubview(viewToAnimateFromCopy)
        
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: animationOptions, animations: {
            viewToAnimateFromCopy.frame = viewEndFrame
            viewToAnimateFromCopy.center = viewEndCenter
        }) { (finished) in
            transitionObject.viewToAnimateFrom?.hidden = false
            transitionObject.viewToAnimateTo?.hidden = false
            viewToAnimateFromCopy.removeFromSuperview()
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
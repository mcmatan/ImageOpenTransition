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
    
    init(transitionObjects : Array<ImageScaleTransitionObject>) {
        self.transitionObjects  = transitionObjects
        super.init()
        self.duration = self.maximumDuration(self.transitionObjects)
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
        
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(self.duration/2 * Double(NSEC_PER_SEC)))
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
        
        transitionObject.viewToAnimateTo?.hidden = true
        transitionObject.viewToAnimateFrom.hidden = true
    
        let viewEndFrame = transitionObject.frameToAnimateTo
        
        let viewToAnimateFromCopy = UIImageView(image: transitionObject.viewToAnimateFrom.image!.copyMe())
        viewToAnimateFromCopy.contentMode = UIViewContentMode.ScaleAspectFill
        viewToAnimateFromCopy.clipsToBounds = true
        
        viewToAnimateFromCopy.frame = transitionObject.frameToAnimateTo
        let viewStartingCenter = transitionObject.viewToAnimateFrom.superview!.convertPoint(transitionObject.viewToAnimateFrom.center, toView: fromViewController.view)
        viewToAnimateFromCopy.center = viewStartingCenter;
        containerView.addSubview(viewToAnimateFromCopy)
        
        UIView.animateWithDuration(self.duration, delay: 0, options: animationOptions, animations: {
            viewToAnimateFromCopy.frame = viewEndFrame
        }) { (finished) in
            if (finished == true) {
                
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    
                    transitionObject.viewToAnimateTo?.hidden = false
                    transitionObject.viewToAnimateFrom?.hidden = false
                    viewToAnimateFromCopy.hidden = true

                }
                
            }
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
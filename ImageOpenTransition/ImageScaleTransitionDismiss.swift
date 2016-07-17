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
    let fadeOutAnimationDuration : NSTimeInterval
    let alphaZero : CGFloat = 0

    init(transitionObjects : Array<ImageScaleTransitionObject>, usingNavigationController : Bool, duration: NSTimeInterval, fadeOutAnimationDuration : NSTimeInterval) {
        self.transitionObjects  = transitionObjects
        self.usingNavigationController = usingNavigationController
        self.fadeOutAnimationDuration = fadeOutAnimationDuration
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

        if self.usingNavigationController == true {
            containerView!.addSubview((toViewController!.view)!)
        }
        
        fromViewController!.view.alpha = 1
        containerView!.addSubview((fromViewController!.view)!)

        for transitionObject in self.transitionObjects {
            self.animateTransitionObject(transitionObject, fromViewController: fromViewController!, toViewController: toViewController!, containerView: containerView!)
        }

        UIView.animateWithDuration(self.duration, animations: {
            fromViewController?.view.alpha = self.alphaZero
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

    func animateTransitionObject(transitionObject : ImageScaleTransitionObject, fromViewController : UIViewController, toViewController : UIViewController, containerView : UIView) {

        let viewEndCenter = fromViewController.view!.convertPoint(transitionObject.viewToAnimateFrom.center, toView: containerView)

        transitionObject.viewToAnimateTo?.hidden = true
        transitionObject.viewToAnimateFrom.hidden = true

        let animationDuration = transitionObject.duration
        var viewEndFrame = transitionObject.viewToAnimateFrom.superview!.convertRect(transitionObject.viewToAnimateFrom.frame, toView: containerView)
        
        var viewToAnimateFromCopy = self.getImageFromImageScaleTransitionObject(transitionObject)

        if let isViewToAnimateTo = transitionObject.viewToAnimateTo?.frame {
            viewToAnimateFromCopy.frame = isViewToAnimateTo
        } else {
            viewToAnimateFromCopy.frame = transitionObject.frameToAnimateTo
        }

        
        let viewHasRoundedCorders = transitionObject.viewToAnimateFrom.layer.cornerRadius == transitionObject.viewToAnimateFrom.frame.size.height/2;
        let scaleSize = viewEndFrame.height/viewToAnimateFromCopy.frame.height
        if (viewHasRoundedCorders == true) {
            viewToAnimateFromCopy.layer.cornerRadius = viewToAnimateFromCopy.frame.size.height/2
        }

        containerView.addSubview(viewToAnimateFromCopy)

        UIView.animateWithDuration(transitionObject.duration, delay: 0, options: animationOptions, animations: {
            
            if viewHasRoundedCorders == true {
                viewToAnimateFromCopy.center = viewEndCenter
                viewToAnimateFromCopy.transform = CGAffineTransformMakeScale(scaleSize, scaleSize)
            } else {
                viewToAnimateFromCopy.frame = viewEndFrame
            }
            }) { (finished) in}
        
       let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(self.duration * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            UIView.animateWithDuration(self.fadeOutAnimationDuration, animations: {
                viewToAnimateFromCopy.alpha = self.alphaZero;
                }, completion: { (done) in
                    transitionObject.viewToAnimateTo?.hidden = false
                    transitionObject.viewToAnimateFrom?.hidden = false
                    viewToAnimateFromCopy.hidden = true
            })
            
        }
    }

    
    func getImageFromImageScaleTransitionObject(transitionObject : ImageScaleTransitionObject)->UIImageView {
        var viewToAnimateFromCopy : UIImageView!
        if let isImageInViewToAnimateFrom = transitionObject.viewToAnimateFrom.image {
            viewToAnimateFromCopy = UIImageView(image: isImageInViewToAnimateFrom.copyMe())
            viewToAnimateFromCopy.contentMode = UIViewContentMode.ScaleAspectFill
        }
        
        if let isImageInViewToAnimateTo = transitionObject.viewToAnimateTo!.image {
            viewToAnimateFromCopy = UIImageView(image: isImageInViewToAnimateTo.copyMe())
            viewToAnimateFromCopy.contentMode = UIViewContentMode.ScaleAspectFill
        }
        
        assert(viewToAnimateFromCopy != nil, "Trying to animate with no Image")
        
        viewToAnimateFromCopy.clipsToBounds = true
        
        return viewToAnimateFromCopy
    }
}

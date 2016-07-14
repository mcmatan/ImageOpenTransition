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

    init(transitionObjects : Array<ImageScaleTransitionObject>, usingNavigationController : Bool, duration: NSTimeInterval) {
        self.transitionObjects  = transitionObjects
        self.usingNavigationController = usingNavigationController
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
            fromViewController?.view.alpha = 0
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

        let viewEndCenter = transitionObject.viewToAnimateFrom.superview!.convertPoint(transitionObject.viewToAnimateFrom.center, toView: containerView)

        transitionObject.viewToAnimateTo?.hidden = true
        transitionObject.viewToAnimateFrom.hidden = true

        let animationDuration = transitionObject.duration
        var viewEndFrame = transitionObject.viewToAnimateFrom.frame
        viewEndFrame.origin.y = viewEndCenter.y - (viewEndFrame.height / 2)
        viewEndFrame.origin.x = viewEndCenter.x - (viewEndFrame.width / 2)

        let viewToAnimateFromCopy = UIImageView(image: transitionObject.viewToAnimateFrom.image!.copyMe())
        viewToAnimateFromCopy.contentMode = UIViewContentMode.ScaleAspectFill

        if let isViewToAnimateTo = transitionObject.viewToAnimateTo?.frame {
            viewToAnimateFromCopy.frame = isViewToAnimateTo
        } else {
            viewToAnimateFromCopy.frame = transitionObject.frameToAnimateTo
        }

        viewToAnimateFromCopy.clipsToBounds = true
        
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

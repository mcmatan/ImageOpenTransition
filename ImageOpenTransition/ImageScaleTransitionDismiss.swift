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
    let animationOptions = UIViewAnimationOptions.curveEaseInOut
    var duration : TimeInterval!
    var transitionObjects: Array<ImageScaleTransitionObject>!
    var usingNavigationController : Bool
    let fadeOutAnimationDuration : TimeInterval
    let alphaZero : CGFloat = 0
    let fadeOutAnimationDelay : TimeInterval

    init(transitionObjects : Array<ImageScaleTransitionObject>, usingNavigationController : Bool, duration: TimeInterval, fadeOutAnimationDuration : TimeInterval, fadeOutAnimationDelay : TimeInterval) {
        self.transitionObjects  = transitionObjects
        self.usingNavigationController = usingNavigationController
        self.fadeOutAnimationDuration = fadeOutAnimationDuration
        self.fadeOutAnimationDelay = fadeOutAnimationDelay
        super.init()
        self.duration = duration
    }

    @objc func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }

    @objc func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containerView = transitionContext.containerView

        if self.usingNavigationController == true {
            containerView.addSubview((toViewController!.view)!)
        }
        
        fromViewController!.view.alpha = 1
        containerView.addSubview((fromViewController!.view)!)

        for transitionObject in self.transitionObjects {
            self.animateTransitionObject(transitionObject: transitionObject, fromViewController: fromViewController!, toViewController: toViewController!, containerView: containerView)
        }

        UIView.animate(withDuration: self.duration, animations: {
            fromViewController?.view.alpha = self.alphaZero
            }, completion: nil)
        
        afterDelay(seconds: self.duration) { 
            UIView.animate(withDuration: self.duration/2, animations: {
                toViewController?.view.alpha = 1.0
                }, completion: { (finish) in
                    transitionContext.completeTransition(true)
            })
        }
    }

    func animateTransitionObject(transitionObject : ImageScaleTransitionObject, fromViewController : UIViewController, toViewController : UIViewController, containerView : UIView) {

        let viewEndCenter = fromViewController.view!.convert(transitionObject.viewToAnimateFrom.center, to: containerView)

        transitionObject.viewToAnimateTo.isHidden = true
        transitionObject.viewToAnimateFrom.isHidden = true

        _ = transitionObject.duration
        
        let viewToAnimateFromCopy = self.getImageFromImageScaleTransitionObject(transitionObject: transitionObject)
        viewToAnimateFromCopy.frame = self.startFrame(transitionObject: transitionObject, withNavigationController: self.usingNavigationController, controllerAnimatingFrom: fromViewController ,controllerAnimatingTo: toViewController)
        let viewEndFrame = self.endFrame(transitionObject: transitionObject, containerView: containerView).frame
        if self.endFrame(transitionObject: transitionObject, containerView: containerView).hasSet == false {
            viewToAnimateFromCopy.isHidden = true
        }

        
        let viewHasRoundedCorders = transitionObject.viewToAnimateFrom.layer.cornerRadius == transitionObject.viewToAnimateFrom.frame.size.height/2;
        let scaleSize = viewEndFrame.height/viewToAnimateFromCopy.frame.height
        if (viewHasRoundedCorders == true) {
            viewToAnimateFromCopy.layer.cornerRadius = viewToAnimateFromCopy.frame.size.height/2
        }

        containerView.addSubview(viewToAnimateFromCopy)

        UIView.animate(withDuration: transitionObject.duration, delay: 0, options: animationOptions, animations: {
            
            if viewHasRoundedCorders == true {
                viewToAnimateFromCopy.center = viewEndCenter
                viewToAnimateFromCopy.transform = CGAffineTransform(scaleX: scaleSize, y: scaleSize)
            } else {
                viewToAnimateFromCopy.frame = viewEndFrame
            }
            }) { (finished) in}
        

        afterDelay(seconds: (transitionObject.duration + self.fadeOutAnimationDelay)) { 
            viewToAnimateFromCopy.removeFromSuperview()
            transitionObject.viewToAnimateTo.isHidden = false
            transitionObject.viewToAnimateFrom?.isHidden = false
        }
    }

    
    func getImageFromImageScaleTransitionObject(transitionObject : ImageScaleTransitionObject)->UIImageView {
        var viewToAnimateFromCopy : UIImageView!
        if let isImageInViewToAnimateFrom = transitionObject.viewToAnimateFrom.image {
            viewToAnimateFromCopy = UIImageView(image: isImageInViewToAnimateFrom.copyMe())
            viewToAnimateFromCopy.contentMode = UIViewContentMode.scaleAspectFill
        }
        
        if let isImageInViewToAnimateTo = transitionObject.viewToAnimateTo.image {
            viewToAnimateFromCopy = UIImageView(image: isImageInViewToAnimateTo.copyMe())
            viewToAnimateFromCopy.contentMode = UIViewContentMode.scaleAspectFill
        }
        
        assert(viewToAnimateFromCopy != nil, "Trying to animate with no Image")
        
        viewToAnimateFromCopy.clipsToBounds = true
        
        return viewToAnimateFromCopy
    }
    
    func startFrame(transitionObject : ImageScaleTransitionObject, withNavigationController : Bool, controllerAnimatingFrom : UIViewController, controllerAnimatingTo : UIViewController)->CGRect {
        var frame = transitionObject.viewToAnimateTo.frame
        if withNavigationController == true && controllerAnimatingTo.navigationController?.navigationBar.isTranslucent == false {
            frame.origin.y += controllerAnimatingFrom.heightOfNavigationControllerAndStatusAtViewController()
        }
        return frame
        
    }
    
    func endFrame(transitionObject : ImageScaleTransitionObject, containerView : UIView)->(frame : CGRect , hasSet : Bool) {
        var viewEndFrame = transitionObject.viewToAnimateFrom.frame
        if transitionObject.viewToAnimateFrom.superview != nil {
            viewEndFrame = transitionObject.viewToAnimateFrom.superview!.convert(transitionObject.viewToAnimateFrom.frame, to: containerView)
            return (viewEndFrame, true)
        } else {
            print("Error: The view you are trying to animate to in dissmess, has no super view")
        }
        return (viewEndFrame, false)
    }
}

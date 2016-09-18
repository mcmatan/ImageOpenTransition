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
    let animationOptions = UIViewAnimationOptions.curveEaseInOut
    var duration : TimeInterval!
    var transitionObjects: Array<ImageScaleTransitionObject>!
    let fadeOutAnimationDuration : TimeInterval
    let alphaZero : CGFloat = 0
    let fadeOutAnimationDelay : TimeInterval
    let fromViewControllerScaleAnimation : CGFloat
    let usingNavigationController : Bool
    
    init(transitionObjects : Array<ImageScaleTransitionObject>, duration: TimeInterval, fadeOutAnimationDuration : TimeInterval, fadeOutAnimationDelay : TimeInterval, fromViewControllerScaleAnimation : CGFloat, usingNavigationController : Bool) {
        self.transitionObjects  = transitionObjects
        self.fadeOutAnimationDuration = fadeOutAnimationDuration
        self.fadeOutAnimationDelay = fadeOutAnimationDelay
        self.fromViewControllerScaleAnimation = fromViewControllerScaleAnimation
        self.usingNavigationController = usingNavigationController
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
        
        toViewController!.view.alpha = alphaZero
        containerView.addSubview((toViewController!.view)!)
        
        if self.usingNavigationController == true && toViewController?.navigationController?.navigationBar.isTranslucent == false {
            toViewController!.view.frame.origin.y += (toViewController?.heightOfNavigationControllerAndStatusAtViewController())!
            toViewController!.view.frame.size.height -= (toViewController?.navigationController?.navigationBar.frame.size.height)!
        }
        
        for transitionObject in self.transitionObjects {
            self.animateTransitionObject(transitionObject: transitionObject, fromViewController: fromViewController!, toViewController: toViewController!, containerView: containerView)
        }

        let scaleUp = CGAffineTransform(scaleX: self.fromViewControllerScaleAnimation, y: self.fromViewControllerScaleAnimation);
        let scaleDown = CGAffineTransform(scaleX: 1.0, y: 1.0);
        
            UIView.animate(withDuration: self.duration, animations: {
                toViewController?.view.alpha = 1.0
                fromViewController?.view.transform = scaleUp
                }, completion: { (finish) in
                    fromViewController?.view.transform = scaleDown
                    transitionContext.completeTransition(true)
            })
        
    }
    

    func animateTransitionObject(transitionObject : ImageScaleTransitionObject, fromViewController : UIViewController, toViewController : UIViewController, containerView : UIView) {
        
        transitionObject.viewToAnimateTo.isHidden = true
        transitionObject.viewToAnimateFrom.isHidden = true
    
        
        var viewEndFrame = toViewController.view!.convert(transitionObject.viewToAnimateTo.frame, to: containerView)
        if let isFrameToAnimateTo = transitionObject.frameToAnimateTo {
            viewEndFrame = isFrameToAnimateTo
        }
        
        
    
        assert(transitionObject.viewToAnimateFrom.image != nil, "Trying to animate with no Image")
        
        let viewToAnimateFromCopy = UIImageView(image: transitionObject.viewToAnimateFrom.image!.copyMe())
        viewToAnimateFromCopy.contentMode = UIViewContentMode.scaleAspectFill
        
        viewToAnimateFromCopy.frame = transitionObject.viewToAnimateFrom.superview!.convert(transitionObject.viewToAnimateFrom.frame, to: containerView)
        
        viewToAnimateFromCopy.clipsToBounds = true
        
        let viewHasRoundedCorders = transitionObject.viewToAnimateFrom.layer.cornerRadius == transitionObject.viewToAnimateFrom.frame.size.height/2;
        let scaleSize = viewEndFrame.height/viewToAnimateFromCopy.frame.height
        if (viewHasRoundedCorders == true) {
            viewToAnimateFromCopy.layer.cornerRadius = viewToAnimateFromCopy.frame.size.height/2
        }
        
        containerView.addSubview(viewToAnimateFromCopy)
        
        UIView.animate(withDuration: transitionObject.duration, delay: 0, options: animationOptions, animations: {
            
            if viewHasRoundedCorders == true {
                viewToAnimateFromCopy.transform = CGAffineTransform(scaleX: scaleSize, y: scaleSize)
                viewToAnimateFromCopy.center = CGPoint(x: viewEndFrame.origin.x + (viewEndFrame.width/2), y: viewEndFrame.origin.y + (viewEndFrame.height/2))
            } else {
                viewToAnimateFromCopy.frame = viewEndFrame
            }
        }) { (finished) in}
        
        afterDelay(seconds: (transitionObject.duration + fadeOutAnimationDelay)) { 
            viewToAnimateFromCopy.removeFromSuperview()
            transitionObject.viewToAnimateTo.isHidden = false
            transitionObject.viewToAnimateFrom?.isHidden = false
        }

    }
}

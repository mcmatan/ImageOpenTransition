//
//  ImageScaleTransitionObject.swift
//  CellOpenTransition
//
//  Created by Matan Cohen on 7/12/16.
//  Copyright © 2016 Jive. All rights reserved.
//

import Foundation
import UIKit

public class ImageScaleTransitionObject : NSObject {
    internal weak var viewToAnimateFrom : UIImageView!
    internal var frameToAnimateTo : CGRect
    internal var viewToAnimateTo :UIImageView? // This is optional, if you do require this, your view will be hidden/unhidden to suite the transition better.
    internal var duration : NSTimeInterval
    
    public init(viewToAnimateFrom : UIImageView, frameToAnimateTo : CGRect, viewToAnimateTo: UIImageView?, duration : NSTimeInterval) {
        self.viewToAnimateFrom = viewToAnimateFrom
        self.frameToAnimateTo = frameToAnimateTo
        self.viewToAnimateTo = viewToAnimateTo
        self.duration = duration
    }
    
}
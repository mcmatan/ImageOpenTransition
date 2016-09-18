//
//  ImageScaleTransitionObject.swift
//  CellOpenTransition
//
//  Created by Matan Cohen on 7/12/16.
//  Copyright © 2016 Jive. All rights reserved.
//

import Foundation
import UIKit

//Should add init for only frame, and check if all works.

public class ImageScaleTransitionObject : NSObject {
    internal var viewToAnimateFrom : UIImageView!
    internal var frameToAnimateTo : CGRect?
    internal var viewToAnimateTo :UIImageView // This is optional, if you do require this, your view will be hidden/unhidden to suite the transition better.
    internal var duration : TimeInterval
    
    
    public init(viewToAnimateFrom : UIImageView, viewToAnimateTo: UIImageView, duration : TimeInterval, frameToAnimateTo : CGRect) {
        self.viewToAnimateFrom = viewToAnimateFrom
        self.frameToAnimateTo = frameToAnimateTo
        self.viewToAnimateTo = viewToAnimateTo
        self.duration = duration
    }
    
    public init(viewToAnimateFrom : UIImageView, viewToAnimateTo: UIImageView, duration : TimeInterval) {
        self.viewToAnimateFrom = viewToAnimateFrom
        self.viewToAnimateTo = viewToAnimateTo
        self.duration = duration
    }
}

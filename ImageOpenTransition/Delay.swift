//
//  Delay.swift
//  ImageOpenTransition
//
//  Created by Antonio Alves on 7/23/16.
//  Copyright © 2016 Jive. All rights reserved.
//

import Foundation


func afterDelay(seconds: Double, completion:() -> Void) {
    let when = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
    dispatch_after(when, dispatch_get_main_queue(), completion)
}
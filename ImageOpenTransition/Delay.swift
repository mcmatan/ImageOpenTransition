//
//  Delay.swift
//  ImageOpenTransition
//
//  Created by Antonio Alves on 7/23/16.
//  Copyright © 2016 Jive. All rights reserved.
//

import Foundation


func afterDelay(seconds: Double, completion: @escaping () -> Void) {
    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute:completion)
}

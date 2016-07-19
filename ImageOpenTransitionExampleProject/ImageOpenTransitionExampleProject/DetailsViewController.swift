//
//  DetailsViewController.swift
//  CellOpenTransition
//
//  Created by Matan Cohen on 7/12/16.
//  Copyright © 2016 Jive. All rights reserved.
//

import Foundation
import UIKit

class DetailsViewController : UIViewController {
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func btnDoneTaped(sender: AnyObject) {
        if let isNavigationController = self.navigationController {
            isNavigationController.popViewControllerAnimated(true)
        } else {
        self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
}
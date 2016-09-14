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
    
    
    @IBAction func btnDoneTaped(_ sender: AnyObject) {
        if let isNavigationController = self.navigationController {
            isNavigationController.popViewController(animated: true)
        } else {
        self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

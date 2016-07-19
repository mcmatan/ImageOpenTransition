//
//  ViewController.swift
//  ImageOpenTransition
//
//  Created by Matan Cohen on 7/13/16.
//  Copyright © 2016 Jive. All rights reserved.
//

import UIKit
import ImageOpenTransition

    class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate{
        @IBOutlet weak var tableView: UITableView!
        var imageScalePresentTransition :ImageScaleTransitionDelegate? = nil
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            self.transitioningDelegate = self.imageScalePresentTransition
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        override func viewDidAppear(animated: Bool) {
            super.viewDidAppear(animated)
            
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
            if let isCell = cell {
                return isCell
            } else {
                assert(true, "Cell is nil")
                return UITableViewCell()
            }
        }
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 10
        }
        
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("DetailsViewController") as! DetailsViewController
            vc.loadView()
            
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! ViewControllerCell
            
            let avatarImageSize : CGFloat = 60
            let avatarYPoint : CGFloat = 160
            let frameToAnimateToAvatar = CGRectMake((self.view.frame.size.width/2) - (avatarImageSize/2), avatarYPoint, avatarImageSize, avatarImageSize)
            let frameToAnimateToCover = CGRectMake(0, 0, self.view.frame.size.width, 200)
            
            var usingNavigationController = false
            if let _ = self.navigationController {
                usingNavigationController = true
            }
            
            let transitionObjectAvatar = ImageScaleTransitionObject(viewToAnimateFrom: cell.imgAvater, viewToAnimateTo: vc.imgAvatar, duration: 0.4, frameToAnimateTo: frameToAnimateToAvatar)
            let transitionObjectCover = ImageScaleTransitionObject(viewToAnimateFrom: cell.imgCover, viewToAnimateTo: vc.imgCover, duration: 0.4, frameToAnimateTo: frameToAnimateToCover)
            
            self.imageScalePresentTransition = ImageScaleTransitionDelegate(transitionObjects: [transitionObjectCover, transitionObjectAvatar], usingNavigationController: usingNavigationController, duration: 0.4)
            
            if usingNavigationController == true {
                self.navigationController!.delegate = self.imageScalePresentTransition
                self.navigationController!.pushViewController(vc, animated: true)
            } else {
                vc.transitioningDelegate = self.imageScalePresentTransition;
                vc.modalPresentationStyle = UIModalPresentationStyle.Custom;
                self.presentViewController(vc, animated: true, completion: nil)
            }
            
            
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        
        
}

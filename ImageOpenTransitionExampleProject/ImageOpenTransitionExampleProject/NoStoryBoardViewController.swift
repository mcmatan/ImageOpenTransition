//
//  NoStoryBoardViewController.swift
//  ImageOpenTransitionExampleProject
//
//  Created by Matan Cohen on 7/20/16.
//  Copyright © 2016 Jive. All rights reserved.
//

import Foundation
import UIKit

class NoStoryBoardViewController : UIViewController {
    var imgCover: UIImageView!
    var imgAvatar: UIImageView!
    
    override func loadView() {
        super.loadView()
        
        let avatarImageSize : CGFloat = 60
        let avatarYPoint : CGFloat = 160
        let frameToAnimateToAvatar = CGRectMake((self.view.frame.size.width/2) - (avatarImageSize/2), avatarYPoint, avatarImageSize, avatarImageSize)
        let frameToAnimateToCover = CGRectMake(0, 0, self.view.frame.size.width, 200)

        self.imgCover = UIImageView()
        self.imgCover.image = UIImage(named: "windows-xp-background-image-jpg.jpg")
        self.imgCover.contentMode = UIViewContentMode.ScaleAspectFill
        self.imgCover.clipsToBounds = true
        self.imgCover.frame = frameToAnimateToCover
        self.view.addSubview(self.imgCover)
        
        self.imgAvatar = UIImageView()
        self.imgAvatar.image = UIImage(named: "crossroads-destiny-clip-4x3.jpg")
        self.imgAvatar.frame = frameToAnimateToAvatar
        self.imgAvatar.contentMode = UIViewContentMode.ScaleAspectFill
        self.imgAvatar.clipsToBounds = true
        self.view.addSubview(self.imgAvatar)
        
        self.view.backgroundColor = UIColor.whiteColor()
    }
}
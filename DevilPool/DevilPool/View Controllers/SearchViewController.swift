//
//  SearchViewController.swift
//  DevilPool
//
//  Created by Administrator on 7/16/15.
//  Copyright (c) 2015 oncloudcal.com. All rights reserved.
//

import Parse
import ParseUI
import FBSDKCoreKit
import UIKit
import QuartzCore

class SearchViewController: UIViewController {

    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var displayPicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayName.text = PFUser.currentUser()!.username
        
        if let profileImage = PFUser.currentUser()?.valueForKey("profilePicture") as? PFFile {
            
            // TODO Add Local Storage for Profile Pictures.
            profileImage.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                if let data = data {
                    let image = UIImage(data: data, scale:1.0)!
                    self.displayPicture.layer.masksToBounds = true
                    self.displayPicture.image = image
                    self.displayPicture.layer.cornerRadius = self.displayPicture.frame.width/2
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

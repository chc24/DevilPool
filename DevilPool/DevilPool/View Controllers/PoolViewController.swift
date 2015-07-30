//
//  PoolViewController.swift
//  DevilPool
//
//  Created by Administrator on 7/16/15.
//  Copyright (c) 2015 oncloudcal.com. All rights reserved.
//

import UIKit

class PoolViewController: UIViewController {

    @IBOutlet weak var poolBarEnable: UITabBarItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO : move to ParseHelper
        
        var query = PFQuery(className: "Post")
        query.whereKey("fromUser", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock { (posts, error: NSError?) -> Void in
            println("query callback")
            
            //display posts
            if let posts = posts as? [PFObject] {
                println("posts not empty")
                
                for item in posts {
                    println(item["fromUser"]!.username)
                }
                
                
            
            }
            
            
            
            //display no current posts
            
        
        
        //Check if Current user has any posts or groups committed == query for posts
        
        
        
        //Display Posts
        
        //Display Groups
            
        }
        println("query completed")
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

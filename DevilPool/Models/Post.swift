//
//  Post.swift
//  DevilPool
//
//  Created by Administrator on 7/21/15.
//  Copyright (c) 2015 oncloudcal.com. All rights reserved.
//

import UIKit
import Parse

class Post: PFObject, PFSubclassing {
   
    var onDate: NSDate?
    var fromTime: NSDate?
    var toTime: NSDate?
    var destination: String?
    
    @NSManaged var post: PFObject?
    
    func uploadPost() {
        println("uploading")
        
        let post = PFObject(className: "Post")
        if let onDate = onDate {
            post["onDate"] = onDate
        }
        if let fromTime = fromTime {
            post["fromTime"] = fromTime
        }
        if let toTime = toTime {
            post["toTime"] = toTime
        }
        if let destination = destination {
            post["Destination"] = destination
        }
        
        post["fromUser"] = PFUser.currentUser()
        
        
        var relation = post.relationForKey("userPool")
        relation.addObject(PFUser.currentUser()!)
        
//        var userPosts = PFUser.currentUser()?.relationForKey("userPosts")
//        userPosts?.addObject(post)
//        PFUser.currentUser()?.saveInBackground()
//        
        post.saveInBackgroundWithBlock( {
            (success: Bool, error: NSError?) -> Void in
            
            if error == nil {
                //
            } else {
                println(error)
            }
        })
        
        
        
    }
    static func parseClassName() -> String {
        return "Post"
    }
    
    // 4
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
            
        }
    }

}

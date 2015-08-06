//
//  ParseHelper.swift
//  DevilPool
//
//  Created by Administrator on 7/24/15.
//  Copyright (c) 2015 oncloudcal.com. All rights reserved.
//

import UIKit
import Parse

class ParseHelper {
   
    //Post Class
    static let PostClass = "Post"
    static let PostOnDate = "onDatE"
    static let PostUser = "fromUser"
    static let PostFromTime = "fromTime"
    static let PostToTime = "toTime"
    static let PostRelations = "userPool"
    static let PostDestination = "Destination"
    
    //User
    static let UserCarpools = "userPools"
    static let UserEmailVerified = "emailVerified"
    static let UserName = "username"
    static let UserEmail = "email"
    static let UserPhone = "phoneNumber"
    static let UserFBID = "FacebookID"
    
    
    func uploadPost() {
        return
    }
    
    static func getProfilePicture() {
        
    }
    
    static func updateUser() {
        
    }
    static func updateUserCarpools() {
        
    }
    
    static func updatePostsRelations() {
        
    }
    
    static func findPostsOnDate(date: NSDate, completionBlock: PFArrayResultBlock) {
        var query = PFQuery(className: PostClass)
        query.whereKey("onDate", equalTo: date)
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func findAllRelations() {
        
    }
    
    
    
}

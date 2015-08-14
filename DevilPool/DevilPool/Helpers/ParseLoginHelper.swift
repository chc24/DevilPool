//
//  ParseLoginHelper.swift
//  DevilPool
//
//  Created by Administrator on 7/16/15.
//  Copyright (c) 2015 oncloudcal.com. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import Parse
import ParseUI

typealias ParseLoginHelperCallback = (PFUser?, NSError?) -> Void

/**
This class implements the 'PFLogInViewControllerDelegate' protocol. After a successfull login
it will call the callback function and provide a 'PFUser' object.
*/
class ParseLoginHelper : NSObject, NSObjectProtocol {
    static let errorDomain = "com.makeschool.parseloginhelpererrordomain"
    static let usernameNotFoundErrorCode = 1
    static let usernameNotFoundLocalizedDescription = "Could not retrieve Facebook username"
    
    let callback: ParseLoginHelperCallback
    
    init(callback: ParseLoginHelperCallback) {
        self.callback = callback
    }
}

extension ParseLoginHelper : PFLogInViewControllerDelegate {
    
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        println("Hi i'm called")
        // Determine if this is a Facebook login
        let isFacebookLogin = FBSDKAccessToken.currentAccessToken() != nil
        println("Checking obj ID")
        if !isFacebookLogin {
            // Plain parse login, we can return user immediately
            self.callback(user, nil)
        } else {
            // if this is a Facebook login, fetch the username from Facebook
            FBSDKGraphRequest(graphPath: "me", parameters: nil).startWithCompletionHandler {
                (connection: FBSDKGraphRequestConnection!, result: AnyObject?, error: NSError?) -> Void in
                if let error = error {
                    // Facebook Error? -> hand error to callback
                    self.callback(nil, error)
                }
                
                if let fbUsername = result?["name"] as? String {
                    // assign Facebook name to PFUser
                    println(result)
                    
                    
                    let facebookID: String = result?["id"] as! String
                    let pictureURL = "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1"
                    
                    var URLRequest = NSURL(string: pictureURL)
                    var URLRequestNeeded = NSURLRequest(URL: URLRequest!)
                    
                    NSURLConnection.sendAsynchronousRequest(URLRequestNeeded, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!, error: NSError!) -> Void in
                        if error == nil {
                            var picture = PFFile(data: data)
                            user.setObject(picture, forKey: "profilePicture")
                            user.setObject(facebookID, forKey: "FacebookID")
                            user.saveInBackground()
                        }
                        else {
                            println("Error: \(error.localizedDescription)")
                        }
                    })
                    
                    
                    
                    user.username = fbUsername
                    // store PFUser
                    user.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                        
                        
                        if (success) {
                            // updated username could be stored -> call success
                            self.callback(user, error)
                        } else {
                            // updating username failed -> hand error to callback
                            self.callback(nil, error)
                        }
                    })
                } else {
                    // cannot retrieve username? -> create error and hand it to callback
                    let userInfo = [NSLocalizedDescriptionKey : ParseLoginHelper.usernameNotFoundLocalizedDescription]
                    let noUsernameError = NSError(
                        domain: ParseLoginHelper.errorDomain,
                        code: ParseLoginHelper.usernameNotFoundErrorCode,
                        userInfo: userInfo
                    )
                    self.callback(nil, error)
                }
            }
        }
    }
    
}

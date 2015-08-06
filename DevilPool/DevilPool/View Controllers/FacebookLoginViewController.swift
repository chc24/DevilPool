//
//  FacebookLoginViewController.swift
//  DevilPool
//
//  Created by Administrator on 7/16/15.
//  Copyright (c) 2015 oncloudcal.com. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


class FacebookLoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if (FBSDKAccessToken.currentAccessToken() == nil){
            println("Not logged in")
        }
        else{
            println("Logged in")
        }
        
        var loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile"]
        loginButton.center = self.view.center
        
        loginButton.delegate = self
        
        self.view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error == nil{
            println("User logged in")
            self.performSegueWithIdentifier("FBLoginToTabs", sender: self)
        }
        else{
            println(error.localizedDescription)
        }
        
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User logged out")
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

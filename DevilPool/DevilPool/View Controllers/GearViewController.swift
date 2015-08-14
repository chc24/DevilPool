//
//  GearViewController.swift
//  DevilPool
//
//  Created by Administrator on 7/16/15.
//  Copyright (c) 2015 oncloudcal.com. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Parse

class GearViewController: UIViewController, FBSDKLoginButtonDelegate{

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var displayPicture: UIImageView!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func AboutButtonClicked(sender: AnyObject) {
    }
    @IBAction func FacebookButtonClicked(sender: AnyObject) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        if FBSDKAccessToken.currentAccessToken() == nil {
            println("logged out")
            
            //Redirect to custom log in page
            
        }
    }
    @IBAction func segmentedControlSwitched(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        
//        var loginButton = FBSDKLoginButton()
//        loginButton.readPermissions = ["public_profile"]
//        loginButton.center.x = self.view.center.x
//        loginButton.center.y = self.view.center.y + 100
//        
//        loginButton.delegate = self
//        
//        self.view.addSubview(loginButton)
        
        
        facebookButton.backgroundColor = UIColor.clearColor()
        facebookButton.layer.cornerRadius = 5
        facebookButton.layer.borderWidth = 1
        facebookButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.username.text = PFUser.currentUser()?.username
        
        if let profileImage = PFUser.currentUser()?.valueForKey("profilePicture") as? PFFile {
            
            // TODO Add Local Storage for Profile Pictures.
            
            profileImage.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                if let data = data {
                    let image = UIImage(data: data, scale:1.0)!
                    
                    self.displayPicture.image = image
                    self.displayPicture.layer.masksToBounds = true
                    self.displayPicture.layer.cornerRadius = self.displayPicture.frame.width/2
                }
            }
        }

        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        //Disable and notify if no posts/carpools
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

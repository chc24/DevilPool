//
//  VerifyViewController.swift
//  DevilPool
//
//  Created by Administrator on 7/17/15.
//  Copyright (c) 2015 oncloudcal.com. All rights reserved.
//

import UIKit
import Parse

class VerifyViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var checkVerifiedButton: UIButton!
    
    @IBOutlet weak var verifyButton: UIButton!
    @IBAction func verifyEmailPressed(sender: AnyObject) {
        
        //TODO move to ParseHelper
        
        checkVerifiedButton.hidden = false
        emailField.resignFirstResponder()
        if let email = emailField.text {
            if verifyEmail(email) {
                PFUser.currentUser()?.setObject(email, forKey: "email")
                PFUser.currentUser()?.saveInBackground()
                
                var alert = UIAlertController(title: "Email Sent", message: "Please click the confirmation in your email", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        else {
            //empty field
            println("empty field")
        }
    }
    
    
    func verifyEmail(email: String) -> Bool {
        if email.rangeOfString("@duke.edu") != nil {
            return true
        }
        return false
    }
    
    @IBAction func checkVerified(sender: AnyObject) {
        
        //TODO Move to ParseHelper
        println("appeared")
        var user = PFUser.currentUser()
        user?.fetchInBackgroundWithBlock({ (user, NSError) -> Void in
            
            if user!.objectForKey("emailVerified") as! Bool == true {
                
                self.performSegueWithIdentifier("VerifyToHomeView", sender: self)
                
            }
            else {
                var alert = UIAlertController(title: "Sorry, please try again", message: "Please click the confirmation link in your email", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        })
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkVerifiedButton.hidden = true
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

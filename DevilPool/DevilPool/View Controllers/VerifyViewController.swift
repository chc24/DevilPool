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
    
    @IBAction func verifyEmailPressed(sender: AnyObject) {
        if let email = emailField.text {
            PFUser.currentUser()?.setObject(email, forKey: "email")
            PFUser.currentUser()?.saveInBackground()
            
            var alert = UIAlertController(title: "Email Sent", message: "Please click the confirmation in your email", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
                    }
    }
    
    override func viewWillAppear(animated: Bool) {
        var user = PFUser.currentUser()
        if let verified = user!.objectForKey("emailVerified") as? Bool {
            if verified == true {
                self.performSegueWithIdentifier("verifyToHomeView", sender: self)
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

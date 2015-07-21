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

class SearchViewController: UIViewController, DatePickerDelegate {

    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var displayPicture: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var fromTimeLabel: UITextField!
    @IBOutlet weak var toTimeLabel: UITextField!
    
    
    // Handle Repeat Code
    
    var tag = 0
    
    func makeDatePicker(sender: UITextField!) {
        
        var datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.Time
        sender.inputView = datePicker
        datePicker.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func fromTimeLabelClicked(sender: UITextField!) {
        tag = 1
        makeDatePicker(sender)
    }
    @IBAction func toTimeLabel(sender: UITextField!) {
        tag = 2
        makeDatePicker(sender)
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeStyle = .ShortStyle
        if tag == 1{
            fromTimeLabel.text = timeFormatter.stringFromDate(sender.date)
        }
        else {
            toTimeLabel.text = timeFormatter.stringFromDate(sender.date)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Display Facebook Name / Profile Picture
        displayName.text = PFUser.currentUser()!.username
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showCalendar" {
            if let vc = segue.destinationViewController as? DatePickerViewController {
                vc.delegate = self
            }
        }
    }
    
    // MARK: - DatePickerDelegate
    
    func didSelectDate(date: NSDate!) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd"
        
        dateLabel.text = dateFormatter.stringFromDate(date)
        
    }
}

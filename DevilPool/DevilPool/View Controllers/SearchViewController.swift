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

class SearchViewController: UIViewController, DatePickerDelegate{

    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var displayPicture: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet weak var onDateLabel: UITextField!
    @IBOutlet weak var fromTimeLabel: UITextField!
    @IBOutlet weak var toTimeLabel: UITextField!
    @IBOutlet weak var destinationLabel: UITextField!
    
    @IBAction func uploadPost(sender: AnyObject) {
        
        let post = Post()
        
        var timetoString = NSDateFormatter()
        
        timetoString.dateFormat = "MM/dd/yyyy, hh:mm aa"
        let fT = timetoString.dateFromString(onDateLabel.text + ", " + fromTimeLabel.text)
        let tT = timetoString.dateFromString(onDateLabel.text + ", " + toTimeLabel.text)
        
        timetoString.dateFormat = "MM/dd/yyyy"
        let onD = timetoString.dateFromString(onDateLabel.text)
        
        //Create Post
        
        //TODO
        
        post.onDate = onD
        post.fromTime = fT
        post.toTime = tT
        post.destination = destinationLabel.text
        
        //Set read access rights
        let acl = PFACL()
        acl.setPublicReadAccess(true)
        PFACL.setDefaultACL(acl, withAccessForCurrentUser: true)
        
        if fromTimeLabel.text != "" && toTimeLabel.text != "" && destinationLabel.text != "" && onDateLabel.text  != ""{
            post.uploadPost()
            onDateLabel.text = ""
            fromTimeLabel.text = ""
            toTimeLabel.text = ""
            destinationLabel.text = ""
        }
        else {
            println("Fill in fields")
        }
    }
    
    // Handles Date Picker
    
    var tag = 0

    
    func makeDatePicker(sender: UITextField!) {
        
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 240))
        
        var datePickerView: UIDatePicker = UIDatePicker(frame: CGRectMake(0, 40, 0, 0))
        if tag == 3{
            datePickerView.datePickerMode = UIDatePickerMode.Date
        }
        else{
            datePickerView.datePickerMode = UIDatePickerMode.Time
        }
        inputView.addSubview(datePickerView)
        
        let doneButton = UIButton(frame: CGRectMake((self.view.frame.size.width/2) - (100/2), 0, 100, 50))
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitle("Done", forState: UIControlState.Highlighted)
        doneButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        
        inputView.addSubview(doneButton) // add Button to UIView
        
        doneButton.addTarget(self, action: "doneButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside) // set button click event

        sender.inputView = inputView
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if tag == 1{
            fromTimeLabel.resignFirstResponder()
        }
        else if tag == 2{
            toTimeLabel.resignFirstResponder()
        }
        else {
            onDateLabel.resignFirstResponder()
        }
        
        self.view.endEditing(true)
    }
    
    func doneButtonPressed(sender: UIButton) {
        resignDatePicker()
    }
    
    @IBAction func onDateLabelClicked(sender: UITextField!) {
        tag = 3
        makeDatePicker(sender)
    }
    @IBAction func fromTimeLabelClicked(sender: UITextField!) {
        tag = 1
        makeDatePicker(sender)
    }
    @IBAction func toTimeLabel(sender: UITextField!) {
        tag = 2
        makeDatePicker(sender)
    }
    
    func resignDatePicker() {
        if tag == 1{
            fromTimeLabel.resignFirstResponder()
        }
        else if tag == 2{
            toTimeLabel.resignFirstResponder()
        }
        else {
            onDateLabel.resignFirstResponder()
        }
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        var timeFormatter = NSDateFormatter()
        if tag == 3{
            timeFormatter.dateFormat = "MMM dd, yyyy"
            onDateLabel.text = timeFormatter.stringFromDate(sender.date)
        }
        else {
            timeFormatter.dateFormat = "hh:mm aa"
            if tag == 1{
                fromTimeLabel.text = timeFormatter.stringFromDate(sender.date)
            }
            else {
                toTimeLabel.text = timeFormatter.stringFromDate(sender.date)
            }
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
        
        self.destinationLabel.delegate = self
        
        
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

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.destinationLabel.resignFirstResponder()
        return true
    }
}

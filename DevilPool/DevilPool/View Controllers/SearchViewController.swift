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
    
    @IBOutlet weak var onDateLabel: UITextField!
    @IBOutlet weak var fromTimeLabel: UITextField!
    @IBOutlet weak var toTimeLabel: UITextField!
    @IBOutlet weak var destinationLabel: UITextField!
    
    @IBAction func uploadPost(sender: AnyObject) {
        
        //Query all posts and check for match.
        
        var timetoString = NSDateFormatter()
        
        timetoString.dateFormat = "MM/dd/yyyy, hh:mm aa"
        let fT = timetoString.dateFromString(onDateLabel.text + ", " + fromTimeLabel.text)
        let tT = timetoString.dateFromString(onDateLabel.text + ", " + toTimeLabel.text)
        
        timetoString.dateFormat = "MM/dd/yyyy"
        let onD = timetoString.dateFromString(onDateLabel.text)
        
        let query = PFQuery(className: "Post")
        query.whereKey("onDate", equalTo: onD!)
        
        query.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, error: NSError?) -> Void in
            
            if let results = results as? [PFObject] {
                if results.count == 0 {
                    //No Results, upload a post
                    let post = Post()
                    post.onDate = onD
                    post.fromTime = fT
                    post.toTime = tT
                    post.destination = self.destinationLabel.text
                    
                    if self.fromTimeLabel.text != "" && self.toTimeLabel.text != "" && self.destinationLabel.text != "" && self.onDateLabel.text  != ""{
                        post.uploadPost()
                        self.onDateLabel.text = ""
                        self.fromTimeLabel.text = ""
                        self.toTimeLabel.text = ""
                        self.destinationLabel.text = ""
                    }
                    else {
                        println("Fill in fields")
                    }
                    
                } else {
                    //We have matches - so present them.
                    
                    //Matches can be the correct time range, or not
                    var dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "MMM dd"
                    for item in results {
                        println("Carpool found on " + dateFormatter.stringFromDate(item["onDate"] as! NSDate))
                    }
                }
                
            } else { //Error
                
            }
        }
        
        // Perform a Search among all posts > IF no match, then upload.
        
                        //Create Post
        
        //TODO
        
        
        
        //Set read access rights
        
        
        
        
        
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
        
        // Do any additional setup after loading the view.
        
        self.destinationLabel.delegate = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
    // MARK: - DatePickerDelegate
    
    func didSelectDate(date: NSDate!) {
        //TODO
        
        
    }
}


extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.destinationLabel.resignFirstResponder()
        return true
    }
}

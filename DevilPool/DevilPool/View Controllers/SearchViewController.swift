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
    
    var dateHelper = DateHelper()
    var filteredArray: [PFObject] = []
    var tag = 0
    var shouldAdjustView: Bool = false
    
    @IBOutlet weak var onDateLabel: UITextField!
    @IBOutlet weak var fromTimeLabel: UITextField!
    @IBOutlet weak var toTimeLabel: UITextField!
    @IBOutlet weak var destinationLabel: UITextField!
    @IBOutlet weak var SearchButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBAction func uploadPost(sender: AnyObject) {
        
        //Resign all Fields
        resignDatePicker()
        
        //Check if Fields are filled in\\
        if fromTimeLabel.text == "" || toTimeLabel.text == "" || destinationLabel.text == "" || onDateLabel.text  == ""{
            warningLabel.hidden = false
        }
        else {
            warningLabel.hidden = true
            let fT = dateHelper.makeLongDate(onDateLabel.text + ", " + fromTimeLabel.text)
            let tT = dateHelper.makeLongDate(onDateLabel.text + ", " + toTimeLabel.text)
            let onD = dateHelper.makeShortDate(onDateLabel.text)
            
            //Search for posts on Day from Time to Time
            //TODO WITH LOCATION
            ParseHelper.findPostsOnDate(onD) { (results: [AnyObject]?, error: NSError?) -> Void in
                if let error = error { //error handling
                    //TODO SCL ALERT ERROR
                }
                
                if let results = results as? [PFObject] {
                    self.filteredArray = results.filter() { //filter out posts with incorrect timeslots
                        if self.dateHelper.contains(fT, second: tT, third: ($0 as PFObject)){
                            return true
                        } else {
                            return false
                        }
                    }
                    
                    if self.filteredArray.count == 0 {
                        //Ask if they want to upload a post
                        let message = "Sorry, no results were found."
                        var Alert = UIAlertController(title: "Create Post", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                        
                        //Yes
                        Alert.addAction(UIAlertAction(title: "Create Posting", style: .Default, handler: { (action: UIAlertAction!) in
                            let post = Post()
                            post.onDate = onD
                            post.fromTime = fT
                            post.toTime = tT
                            post.destination = self.destinationLabel.text
                            post.uploadPost()
                            self.onDateLabel.text = ""
                            self.fromTimeLabel.text = ""
                            self.toTimeLabel.text = ""
                            self.destinationLabel.text = ""
                        }))
                        //No
                        Alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                            println("Handle Cancel Logic here")
                            
                        }))
                        self.presentViewController(Alert, animated: true, completion: nil)
                        
                        
                    } else {
                        //We have matches - so present them in a table view & prepare for segue
                        self.performSegueWithIdentifier("showResults", sender: self)
                    }
                    
                } else { //Error
                    
                }
            }
        }
        //Set read access rights
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showResults") {
            if let uinav: UINavigationController = segue.destinationViewController as? UINavigationController {
                if let vc = uinav.viewControllers.first as? SearchResultsViewController {
                    vc.results = filteredArray
                }
            }
        }
    }
    
    //Resign Fields
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        resignDatePicker()
        self.view.endEditing(true)
    }
    func doneButtonPressed(sender: UIButton) {
        resignDatePicker()
    }
    func resignDatePicker() {
        if tag == 1{
            fromTimeLabel.resignFirstResponder()
        }
        else if tag == 2{
            toTimeLabel.resignFirstResponder()
        }
        else if tag == 3{
            onDateLabel.resignFirstResponder()
        }
        else {
            destinationLabel.resignFirstResponder()
        }
    }
    
    //Text Field Action Items
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
    @IBAction func destinationLabelTouched(sender: UITextField!) {
        tag = 4
    }
    // Handles Date Picker
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
        
        if tag == 1 {
            self.fromTimeLabel.text = dateHelper.makeShortestString(datePickerView.date)
        }
        else if tag == 2 {
            self.toTimeLabel.text = dateHelper.makeShortestString(datePickerView.date)
        }
        else if tag == 3 {
            self.onDateLabel.text = dateHelper.makeShortString(datePickerView.date)
        }
        
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    func handleDatePicker(sender: UIDatePicker) {
        
        if tag == 3{
            onDateLabel.text = dateHelper.makeShortString(sender.date)
        }
        else {
            if tag == 1{
                fromTimeLabel.text = dateHelper.makeShortestString(sender.date)
            }
            else {
                toTimeLabel.text = dateHelper.makeShortestString(sender.date)
            }
        }
    }
    
    //Adjust Keyboard Frame/View
    func keyboardWillShow(sender: NSNotification) {
        if shouldAdjustView == false && tag != 3 {
            self.view.frame.origin.y -= 150
        }
        shouldAdjustView = true
        
    }
    func keyboardWillHide(sender: NSNotification) {
        if shouldAdjustView == true && tag != 3 {
            self.view.frame.origin.y += 150
        }
        shouldAdjustView = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create Post"
        self.warningLabel.text = "Fill in all fields"
        self.warningLabel.hidden = true
        
        SearchButton.backgroundColor = UIColor.clearColor()
        SearchButton.layer.cornerRadius = 5
        SearchButton.layer.borderWidth = 1
        SearchButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - DatePickerDelegate (Do nothing)
    func didSelectDate(date: NSDate!) {
        //Do nothing
    }
}

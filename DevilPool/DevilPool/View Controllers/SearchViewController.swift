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
    
    @IBOutlet weak var onDateLabel: UITextField!
    @IBOutlet weak var fromTimeLabel: UITextField!
    @IBOutlet weak var toTimeLabel: UITextField!
    @IBOutlet weak var destinationLabel: UITextField!
    
    @IBOutlet weak var SearchButton: UIButton!
    
    @IBAction func uploadPost(sender: AnyObject) {
        
        //Check if Fields are filled in\\
        if self.fromTimeLabel.text == "" || self.toTimeLabel.text == "" || self.destinationLabel.text == "" || self.onDateLabel.text  == ""{
            println("Fill in Fields")
        }
        
        
        //Query all posts and check for match.
        
        //MARK CHANGE
        let fT = dateHelper.makeLongDate(onDateLabel.text + ", " + fromTimeLabel.text)
        let tT = dateHelper.makeLongDate(onDateLabel.text + ", " + toTimeLabel.text)
        
        let onD = dateHelper.makeShortDate(onDateLabel.text)
        
        
        //Search for posts
        ParseHelper.findPostsOnDate(onD) { (results: [AnyObject]?, error: NSError?) -> Void in
            if let error = error {
                //error handling
            }
            if let results = results as? [PFObject] {
                
                //filter out posts with incorrect timeslots
                println("found results")
                println(results)
                self.filteredArray = results.filter() {
                    if self.dateHelper.contains(fT, second: tT, third: ($0 as PFObject)){
                        return true
                    } else {
                        return false
                    }
                }
                println("filtered now")
                println(self.filteredArray)
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
                    //We have matches - so present them in a table view
                    //self.performSegueWithIdentifier("showResults", sender: self)
                    //Matches can be the correct time range, or not
                    self.performSegueWithIdentifier("showResults", sender: self)
//                    let uinav = self.storyboard?.instantiateViewControllerWithIdentifier("searchResultViewController") as? SearchResultsViewController
//                    uinav?.results = self.filteredArray
//                    self.presentViewController(uinav!, animated: true, completion: { () -> Void in
//                    })
                    
                    

                }
                
            } else { //Error
                
            }
        }
        
        
        // Perform a Search among all posts > IF no match, then upload.
        
                        //Create Post
        
        //TODO
        
        
        
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
        
        //MARK EDIT
        var timeFormatter = NSDateFormatter()
        if tag == 3{
            onDateLabel.text = dateHelper.makeShortString(sender.date)
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
        self.title = "Create Post"
        // Do any additional setup after loading the view.
        
        self.destinationLabel.delegate = self
        SearchButton.backgroundColor = UIColor.clearColor()
        SearchButton.layer.cornerRadius = 5
        SearchButton.layer.borderWidth = 1
        SearchButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        
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

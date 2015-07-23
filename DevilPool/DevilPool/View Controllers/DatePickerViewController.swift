//
//  DatePickerViewController.swift
//  DevilPool
//
//  Created by Administrator on 7/20/15.
//  Copyright (c) 2015 oncloudcal.com. All rights reserved.
//

import UIKit
import Parse

protocol DatePickerDelegate {
    func didSelectDate(date: NSDate!)
}

class DatePickerViewController: UIViewController, RSDFDatePickerViewDelegate, RSDFDatePickerViewDataSource {
    
    var delegate : DatePickerDelegate!
    var datePosts : NSMutableSet = NSMutableSet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var query = PFQuery(className: "Post")
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        query.findObjectsInBackgroundWithBlock { (dates: [AnyObject]?, error: NSError?) -> Void in
            
            if let dates = dates as? [PFObject] {
                for item in dates {
                    if let date = item["onDate"] as? NSDate {
                        self.datePosts.addObject(dateFormatter.stringFromDate(date))
                    }
                }
            }
            
            println(self.datePosts)
            
        var datePickerView: RSDFDatePickerView = RSDFDatePickerView(frame: self.view.bounds)
        datePickerView.delegate = self
        datePickerView.dataSource = self
        
        self.view.addSubview(datePickerView)

        }
        
        
        
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
    
    // MARK: RSDFDatePickerViewDelegate
    
    //Query Parse for Dates~
    
    func datePickerView(view: RSDFDatePickerView!, shouldMarkDate date: NSDate!) -> Bool {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        return datePosts.containsObject(dateFormatter.stringFromDate(date))
    }
    
    func datePickerView(view: RSDFDatePickerView!, markImageColorForDate date: NSDate!) -> UIColor! {
        return UIColor.greenColor()
    }
    
    func datePickerView(view: RSDFDatePickerView!, didSelectDate date: NSDate!) {
        println(date.description)
        self.navigationController?.popViewControllerAnimated(true)
        if let delegate = self.delegate {
            delegate.didSelectDate(date)
        }
       
    }
    
    func datePickerViewMarkedDates(view: RSDFDatePickerView!) -> [NSObject : AnyObject]! {
        return [NSObject() : ""]
    }
    
        
}

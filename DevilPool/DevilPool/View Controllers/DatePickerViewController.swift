//
//  DatePickerViewController.swift
//  DevilPool
//
//  Created by Administrator on 7/20/15.
//  Copyright (c) 2015 oncloudcal.com. All rights reserved.
//

import UIKit

protocol DatePickerDelegate {
    func didSelectDate(date: NSDate!)
}

class DatePickerViewController: UIViewController, RSDFDatePickerViewDelegate, RSDFDatePickerViewDataSource {

    var delegate : DatePickerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var datePickerView: RSDFDatePickerView = RSDFDatePickerView(frame: self.view.bounds)
        datePickerView.delegate = self
        datePickerView.dataSource = self
        self.view.addSubview(datePickerView)
        
        
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
    
    func datePickerView(view: RSDFDatePickerView!, didSelectDate date: NSDate!) {
        println(date.description)
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            if let delegate = self.delegate {
                delegate.didSelectDate(date)
            }
        })
    }
    
    func datePickerViewMarkedDates(view: RSDFDatePickerView!) -> [NSObject : AnyObject]! {
        return [NSObject() : ""]
    }

    
}

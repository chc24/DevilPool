//
//  DateHelper.swift
//  DevilPool
//
//  Created by Administrator on 7/31/15.
//  Copyright (c) 2015 oncloudcal.com. All rights reserved.
//

import UIKit

class DateHelper: NSDateFormatter {
    
    var helper: NSDateFormatter = NSDateFormatter()
    
    func makeShorterDate(make: String) -> NSDate{
        helper.dateFormat = "MMM dd"
        return helper.dateFromString(make)!
    }
    
    func makeShortDate(make: String) -> NSDate{
        helper.dateFormat = "MM/dd/yyyy"
        return helper.dateFromString(make)!
    }
    
    func makeLongDate(make: String) -> NSDate{
        helper.dateFormat = "MM/dd/yyyy, hh:mm aa"
        return helper.dateFromString(make)!
    }
    
    func makeShorterString(make: NSDate) -> String {
        helper.dateFormat = "MMM dd"
        return helper.stringFromDate(make)
    }
    
    func makeShortString(make: NSDate) -> String{
        helper.dateFormat = "MMM dd, yyyy"
        return helper.stringFromDate(make)
    }
    
    func makeShortTime(make: NSDate) -> String {
        helper.dateFormat = "hh:mmaa"
        return helper.stringFromDate(make)
    }
    
    func getMonthFromDate(make: NSDate) -> String {
        helper.dateFormat = "MMM"
        return helper.stringFromDate(make)
    }
    
    func getDateFromDate(make: NSDate) -> String {
        helper.dateFormat = "dd"
        return helper.stringFromDate(make)
    }
    
    //COMPARING DATES
    
    //IF first is behind of second
    func isBehind(first: NSDate, second: NSDate) -> Bool{
        return (first < second)
    }
    
    //IF first is ahead of second
    func isAhead(first: NSDate, second: NSDate) -> Bool {
        if !(first < second) {
            return true
        }
        return false
    }
    
    //If they're on same day (excluding time)
    func isSameDay(first: NSDate, second: NSDate) -> Bool{
        return (first == second)
    }
    
    func contains(first: NSDate, second: NSDate, third: PFObject) -> Bool{
        let fT = third["fromTime"] as! NSDate
        let tT = third["toTime"] as! NSDate
        
        //Second contained within post / first/second contained within post
        if (second < tT) && !(second < fT) {
            println("1")
            return true
        }
        
        //Opposite of First
        if first < tT && !(first < fT) {
            println("2")
            return true
        }
        
        else {
            return false
        }
    }
}

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }





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
    
    //Date Formats
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
    
    func makeShortestString(make: NSDate) -> String {
        helper.dateFormat = "hh:mm aa"
        return helper.stringFromDate(make)
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
    func isBehind(first: NSDate, second: NSDate) -> Bool{
        return (first < second)
    }

    func isAhead(first: NSDate, second: NSDate) -> Bool {
        if !(first < second) {
            return true
        }
        return false
    }
    
    func isSameDay(first: NSDate, second: NSDate) -> Bool{
        return (first == second)
    }
    
    func contains(first: NSDate, second: NSDate, third: PFObject) -> Bool{
        let fT = third["fromTime"] as! NSDate
        let tT = third["toTime"] as! NSDate
        
        //Second contained within post / first/second contained within post
        if (second < tT) && !(second < fT) {
            return true
        }
        
        //Opposite of First
        if first < tT && !(first < fT) {
            return true
        }
        
        if first < fT && tT < second {
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





//
//  DateHelper.swift
//  DevilPool
//
//  Created by Administrator on 7/31/15.
//  Copyright (c) 2015 oncloudcal.com. All rights reserved.
//

import UIKit

class DateHelper: NSDateFormatter {
    
    var helper: NSDateFormatter!
    
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
    
}

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }





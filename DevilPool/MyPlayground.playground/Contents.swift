//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let date = "August 02, 2015"
let date2 = "August 02, 2015"
var dateFormatter = NSDateFormatter()

dateFormatter.dateFormat = "MMM dd, yyyy"
println(dateFormatter.dateFromString(date))


//
//  NSDateExtension.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 17/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

extension NSDate {

    func asYYYYMMDD() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.stringFromDate(self)
    }

    func asHHMM() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.stringFromDate(self)
    }

    func asHpm(showMidday showMidday: Bool = false) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ha"
        let time = formatter.stringFromDate(self).lowercaseString
        if showMidday {
            if time == "12pm" {
                return "midday"
            } else if time == "12am" {
                return "midnight"
            }
        }
        return time
    }

    ///  Returns the exact date for the start of today.
    ///
    class func startOfToday() -> NSDate {
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        cal.timeZone = NSTimeZone.localTimeZone()
        let components = cal.components([.Day , .Month, .Year ], fromDate: NSDate())
        return cal.dateFromComponents(components)!
    }
}

extension NSDate: Comparable { }

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

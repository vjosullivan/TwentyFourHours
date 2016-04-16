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

    func asHpm() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ha"
        return formatter.stringFromDate(self).lowercaseString
    }

    ///  Returns the exact date for the local start of today.
    ///
    class func startOfToday() -> NSDate {
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        cal.timeZone = NSTimeZone.localTimeZone()
        let components = cal.components([.Day , .Month, .Year ], fromDate: NSDate())
        return cal.dateFromComponents(components)!
    }
}
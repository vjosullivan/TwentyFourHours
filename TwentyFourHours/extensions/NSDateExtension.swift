//
//  DateExtension.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 17/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

extension Date {

    func asYYYYMMDD() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }

    func asHHMM() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }

    func asHpm() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter.string(from: self).lowercased()
    }

    ///  Returns the exact date for the local start of today.
    ///
    static func startOfToday() -> Date {
        let cal = Calendar(calendarIdentifier: Calendar.Identifier.gregorian)!
        cal.timeZone = TimeZone.local()
        let components = cal.components([.day , .month, .year], from: Date())
        return cal.date(from: components)!
    }


    func isSameDay(date1:Date) -> Bool {
        let calendar = Calendar.current()
        let comps1 = calendar.components([.month, .year, .day], from: date1)
        let comps2 = calendar.components([.month, .year, .day], from: self)

        return (comps1.day == comps2.day) && (comps1.month == comps2.month) && (comps1.year == comps2.year)
    }
}

//extension Date: Comparable { }
//
//public func ==(lhs: Date, rhs: Date) -> Bool {
//    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
//}
//
//public func <(lhs: Date, rhs: Date) -> Bool {
//    return lhs.compare(rhs) == .OrderedAscending
//}


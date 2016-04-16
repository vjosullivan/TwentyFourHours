//
//  NSDateExtensionTests.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 16/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import TwentyFourHours

class NSDateExtensionTests: XCTestCase {

    func testYYYYMMDD() {
        let testTime    = NSDate(timeIntervalSince1970: 1460723696) // 2016-04-15 12:34:56
        XCTAssertEqual("2016-04-15", testTime.asYYYYMMDD())
    }

    func testHHMM() {
        let testTime    = NSDate(timeIntervalSince1970: 1460723696) // 2016-04-15 12:34:56
        let expected    = NSDate(timeIntervalSince1970: 1460723696) // 2016-04-15 12:34:56
        XCTAssertEqual(asHHMM(expected), testTime.asHHMM())
    }

    func testHpm() {
        let testTime    = NSDate(timeIntervalSince1970: 1460723696) // 2016-04-15 12:34:56
        let expected    = NSDate(timeIntervalSince1970: 1460723696) // 2016-04-15 12:34:56
        XCTAssertEqual(asHpm(expected), testTime.asHpm())
    }

    func testStartOfToday() {
        let testTime = NSDate.startOfToday()
        let expected = midNightTodayLocal()
        XCTAssertEqual(expected, testTime)
    }

    /// Returns the given date in a local time format.
    private func asHHMM(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.stringFromDate(date)
    }

    /// Returns the given date in a local time format.
    private func asHpm(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ha"
        return formatter.stringFromDate(date).lowercaseString
    }

    /// Returns midday today as a date.
    private func middayTodayLocal() -> Double {
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        cal.timeZone = NSTimeZone.localTimeZone()
        return cal.dateBySettingHour(12, minute: 0, second: 0, ofDate: NSDate(), options: NSCalendarOptions.MatchFirst)!.timeIntervalSince1970
    }

    /// Returns midnight at the start of today as a date.
    private func midNightTodayLocal() -> NSDate {
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        cal.timeZone = NSTimeZone.localTimeZone()
        return cal.dateBySettingHour(0, minute: 0, second: 0, ofDate: NSDate(), options: NSCalendarOptions.MatchFirst)!
    }

}

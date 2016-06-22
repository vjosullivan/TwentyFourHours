//
//  DateExtensionTests.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 16/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import TwentyFourHours

class DateExtensionTests: XCTestCase {

    func testYYYYMMDD() {
        let testTime    = Date(timeIntervalSince1970: 1460723696) // 2016-04-15 12:34:56
        XCTAssertEqual("2016-04-15", testTime.asYYYYMMDD())
    }

    func testHHMM() {
        let testTime    = Date(timeIntervalSince1970: 1460723696) // 2016-04-15 12:34:56
        let expected    = Date(timeIntervalSince1970: 1460723696) // 2016-04-15 12:34:56
        XCTAssertEqual(asHHMM(expected), testTime.asHHMM())
    }

    func testHpm() {
        let testTime    = Date(timeIntervalSince1970: 1460723696) // 2016-04-15 12:34:56
        let expected    = Date(timeIntervalSince1970: 1460723696) // 2016-04-15 12:34:56
        XCTAssertEqual(asHpm(expected), testTime.asHpm())
    }

    func testStartOfToday() {
        let testTime = Date.startOfToday()
        let expected = midNightTodayLocal()
        XCTAssertEqual(expected, testTime)
    }

    func testSameDay() {
        let date1 = Date(timeIntervalSince1970: 946728000.0) // Midday, Jan 1 2000.
        let date2 = Date(timeIntervalSince1970: 946749600.0) // 6pm, Jan 1 2000.
        XCTAssertTrue(date1.isSameDay(date2))
    }

    func testDifferentDay() {
        let date1 = Date(timeIntervalSince1970: 946728000.0) // Midday, Jan 1 2000.
        let date2 = Date(timeIntervalSince1970: 946814400.0) // Midday, Jan 2 2000.
        XCTAssertFalse(date1.isSameDay(date2))
    }

    func testDatesAreEqual() {
        let date1  = Date(timeIntervalSince1970: 946728000.0) // Midday, Jan 1 2000 UST.
        let date1a = Date(timeIntervalSince1970: 946728000.0) // Midday, Jan 1 2000.
        let date2  = Date(timeIntervalSince1970: 946814400.0) // Midday, Jan 2 2000.
        XCTAssertTrue( date1 == date1a)
        XCTAssertFalse(date1 != date1a)
        XCTAssertFalse(date1 <  date1a)
        XCTAssertTrue( date1 <= date1a)
        XCTAssertFalse(date1 >  date1a)
        XCTAssertTrue( date1 >= date1a)
        XCTAssertFalse(date1 == date2)
        XCTAssertTrue( date1 != date2)
        XCTAssertTrue( date1 <  date2)
        XCTAssertTrue( date1 <= date2)
        XCTAssertFalse(date1 >  date2)
        XCTAssertFalse(date1 >= date2)
    }

    /// Returns the given date in a local time format.
    private func asHHMM(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.stringFromDate(date)
    }

    /// Returns the given date in a local time format.
    private func asHpm(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter.stringFromDate(date).lowercaseString
    }

    /// Returns midday today as a date.
    private func middayTodayLocal() -> Double {
        let cal = Calendar(calendarIdentifier: CalendarIdentifierGregorian)!
        cal.timeZone = TimeZone.localTimeZone()
        return cal.dateBySettingHour(12, minute: 0, second: 0, ofDate: Date(), options: NSCalendarOptions.MatchFirst)!.timeIntervalSince1970
    }

    /// Returns midnight at the start of today as a date.
    private func midNightTodayLocal() -> Date {
        let cal = Calendar(calendarIdentifier: CalendarIdentifierGregorian)!
        cal.timeZone = TimeZone.localTimeZone()
        return cal.dateBySettingHour(0, minute: 0, second: 0, ofDate: Date(), options: NSCalendarOptions.MatchFirst)!
    }

}

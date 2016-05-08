//
//  DayLineTests.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 21/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import TwentyFourHours

class DayLineTests: XCTestCase {

    func testCreatable() {
        let dayLine = DayLine(time: NSDate())
        XCTAssertNotNil(dayLine)
    }

    func testDisplayedText() {
        let now = NSDate()
        let dayLine = DayLine(time: now)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        let expectedText = formatter.stringFromDate(now)

        XCTAssertEqual(expectedText, dayLine.text)
    }
}

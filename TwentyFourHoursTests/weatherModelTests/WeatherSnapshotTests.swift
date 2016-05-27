//
//  CurrentConditionsTests.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 16/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import TwentyFourHours

class WeatherSnapshotTests: XCTestCase {

    func testCreatable() {
        let testTime = 1460723696 // 2016-04-15 12:34:56
        let testIcon = "sun"
        let testSumy = "OK"
        let testTemp = 20.0
        let testUnits = Units(units: "si")
        let current  = WeatherSnapshot(unixTime: testTime, icon: testIcon, summary: testSumy, temperature: testTemp, units: testUnits)
        XCTAssertNotNil(current)
        XCTAssertEqual(testTime, current.unixTime)
        XCTAssertEqual(testIcon, current.icon)
        XCTAssertEqual(testSumy, current.summary)
        XCTAssertEqual(testTemp, current.temperature)
    }

    func testDate() {
        let testTime = 1460723696 // 2016-04-15 12:34:56
        let testDate = NSDate(timeIntervalSince1970: 1460723696) // 2016-04-15 12:34:56
        let current  = WeatherSnapshot(unixTime: testTime, icon: nil, summary: nil, temperature: nil, units: nil)
        XCTAssertEqual(testDate, current.date)
    }
}

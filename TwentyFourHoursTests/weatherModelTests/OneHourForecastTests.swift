//
//  OneHourForecastTests.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 21/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import TwentyFourHours

class OneHourForecastTests: XCTestCase {

    func testCreatable() {
        // Set up test.
        let forecast = OneHourForecast(icon: "", summary: "", temperature: 0.0, time: 1)

        // Run test.
        XCTAssertNotNil(forecast)
    }

    func testEquality() {
        // Set up test.
        let forecast1 = OneHourForecast(icon: "", summary: "Sunny", temperature: 25.0, time: 99)
        let forecast2 = OneHourForecast(icon: "", summary: "Cloudy", temperature: 25.0, time: 99)

        // Perform test.
        XCTAssertEqual(forecast1, forecast2)
    }

    func testLaterDate() {
        // Set up test.
        let forecast1 = OneHourForecast(icon: "", summary: "Sunny", temperature: 25.0, time: 100)
        let forecast2 = OneHourForecast(icon: "", summary: "Cloudy", temperature: 25.0, time: 99)

        // Perform test.
        XCTAssertTrue(forecast1 > forecast2)
    }
}

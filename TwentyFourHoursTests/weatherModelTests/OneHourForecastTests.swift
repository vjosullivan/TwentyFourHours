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
        let forecast = HourlyDataPoint(unixTime: 1, icon: "", summary: "", temperature: 0.0, precipitationIntensity: nil, precipitationProbability: nil, precipitationType: nil, units: nil)

        // Run test.
        XCTAssertNotNil(forecast)
    }

    func testEquality() {
        // Set up test.
        let forecast1 = HourlyDataPoint(unixTime: 1, icon: "", summary: "Sunny", temperature: 25.0, precipitationIntensity: nil, precipitationProbability: nil, precipitationType: nil, units: nil)
        let forecast2 = HourlyDataPoint(unixTime: 1, icon: "", summary: "Cloudy", temperature: 25.0, precipitationIntensity: nil, precipitationProbability: nil, precipitationType: nil, units: nil)

        // Perform test.
        XCTAssertEqual(forecast1, forecast2)
    }

    func testLaterDate() {
        // Set up test.
        let forecast1 = HourlyDataPoint(unixTime: 1_400_000_001, icon: "", summary: "Sunny", temperature: 25.0, precipitationIntensity: nil, precipitationProbability: nil, precipitationType: nil, units: nil)
        let forecast2 = HourlyDataPoint(unixTime: 1_400_000_000, icon: "", summary: "Cloudy", temperature: 25.0, precipitationIntensity: nil, precipitationProbability: nil, precipitationType: nil, units: nil)

        // Perform test.
        XCTAssertTrue(forecast1 > forecast2)
    }
}

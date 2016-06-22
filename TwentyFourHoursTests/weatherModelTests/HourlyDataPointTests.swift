//
//  CurrentDataPointTests.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 16/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import TwentyFourHours

class CurrentDataPointTests: XCTestCase {

    func testCreatable() {
        let testTime = 1460723696 // 2016-04-15 12:34:56
        let testIcon = "sun"
        let testSumy = "OK"
        let testTemp = 20.0
        let testUnits = Units(units: "si")
        let dataPoint  = CurrentDataPoint(unixTime: testTime, icon: testIcon, summary: testSumy, temperature: testTemp, precipitationIntensity: nil, precipitationProbability: nil, precipitationType: nil, units: testUnits)
        XCTAssertNotNil(dataPoint)
        XCTAssertEqual(testTime, dataPoint.unixTime)
        XCTAssertEqual(testIcon, dataPoint.icon)
        XCTAssertEqual(testSumy, dataPoint.summary)
        XCTAssertEqual(testTemp, dataPoint.temperature)
    }

    func testDate() {
        let testTime = 1460723696 // 2016-04-15 12:34:56
        let testDate = Date(timeIntervalSince1970: 1460723696) // 2016-04-15 12:34:56
        let dataPoint  = CurrentDataPoint(unixTime: testTime, icon: nil, summary: nil, temperature: nil, precipitationIntensity: nil, precipitationProbability: nil, precipitationType: nil, units: nil)
        XCTAssertEqual(testDate, dataPoint.date)
    }
}

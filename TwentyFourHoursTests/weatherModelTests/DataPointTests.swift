//
//  DataPointTests.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 07/06/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import TwentyFourHours

/// DataPoint is a protocol, so cannot be tested as such but it comes with helper functions.
///
class DataPointTests: XCTestCase {

    func testDataPointOrder() {
        let dp1  = HourlyDataPoint(unixTime: 1, icon: nil, summary: nil, temperature: nil, precipitationIntensity: nil, precipitationProbability: nil, precipitationType: nil, units: nil)
        let dp1a = HourlyDataPoint(unixTime: 1, icon: nil, summary: nil, temperature: nil, precipitationIntensity: nil, precipitationProbability: nil, precipitationType: nil, units: nil)
        let dp2  = HourlyDataPoint(unixTime: 2, icon: nil, summary: nil, temperature: nil, precipitationIntensity: nil, precipitationProbability: nil, precipitationType: nil, units: nil)
        XCTAssertFalse(dataPointOrder(dp1, point2: dp1a))
        XCTAssertFalse(dataPointOrder(dp1a, point2: dp1))
        XCTAssertTrue(dataPointOrder(dp1, point2: dp2))
        XCTAssertFalse(dataPointOrder(dp2, point2: dp1))
    }
}

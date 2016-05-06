//
//  ForecastIODisplayBuilderTests.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 06/05/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import TwentyFourHours

class ForecastIODisplayBuilderTests: XCTestCase {

    func testCreateable() {
        let builder = ForecastIODisplayBuilder(forecast: nilForecast)
        XCTAssertNotNil(builder)
    }
}

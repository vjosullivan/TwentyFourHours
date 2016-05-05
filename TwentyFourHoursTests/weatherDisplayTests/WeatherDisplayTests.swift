//
//  WeatherDisplayTests.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 05/05/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import TwentyFourHours

class WeatherDisplayTests: XCTestCase {

    func testCreatable() {
        let forecast = Forecast(latitude: nil, longitude: nil, units: Units(units: "si"), currentConditions: nil, oneDayForecasts: nil, oneHourForecasts: nil)
        let weatherDisplay = WeatherDisplay(forecast: forecast)
        XCTAssertNotNil(weatherDisplay)
    }
}

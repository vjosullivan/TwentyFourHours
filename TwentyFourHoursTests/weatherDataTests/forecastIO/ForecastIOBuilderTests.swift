//
//  ForecastIOBuilderTests.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 22/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import TwentyFourHours

class ForecastIOBuilderTests: XCTestCase {

    let emptyForecast = Forecast(latitude: nil, longitude: nil, currentConditions: nil, oneDayForecasts: nil, oneHourForecasts: nil, timezone: nil, offset: nil, units: Units(units: "si"), lines: nil)
    func testCreatable() {
        let builder = ForecastIOBuilder()
        XCTAssertNotNil(builder)
    }

    func testParseNilJSON() {
        let json: JSONDictionary? = nil
        let builder = ForecastIOBuilder()
        var forecast: Forecast?
        do {
            forecast = try builder.parseJSONForecast(json)
            XCTAssertNil(forecast)
        } catch {
            XCTAssert(false, "Nil JSON should not throw an error.")
        }
    }

    func testParseEmptyJSON() {
        let json = JSONDictionary()
        let builder = ForecastIOBuilder()
        var forecast: Forecast?
        do {
            forecast = try builder.parseJSONForecast(json)
            XCTAssertNil(forecast)
        } catch {
            XCTAssert(false, "Empty JSON should not throw an error.")
        }
    }

}

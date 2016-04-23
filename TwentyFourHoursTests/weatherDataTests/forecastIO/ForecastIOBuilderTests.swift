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

    private static let testLatitude  = 51.3
    private static let testLongitude = -1.0
    private static let testUnits     = "uk"
    private static let testUnitsTemperature = "°C"

    static let emptyJSON = JSONDictionary()
    static let basicJSON = ["latitude": testLatitude, "longitude": testLongitude, "units": testUnits]

    var builder: ForecastIOBuilder?

    override func setUp() {
        builder = ForecastIOBuilder()
    }

    func testCreatable() {
        XCTAssertNotNil(builder)
    }

    ///  Test forecast == nil
    func testParseNilJSON() {
        let nilJSON: JSONDictionary? = nil
        var forecast: Forecast?
        do {
            forecast = try builder?.parseJSONForecast(nilJSON)
            XCTAssertNil(forecast)
        } catch {
            XCTAssert(false, "nilJSON should not throw an error.")
        }
    }

    ///  Test forecast not nil but contains no data.
    func testParseEmptyJSON() {
        var forecast: Forecast?
        do {
            forecast = try builder?.parseJSONForecast(ForecastIOBuilderTests.emptyJSON)
            XCTAssertNil(forecast)
        } catch {
            XCTAssert(false, "emptyJSON should not throw an error.")
        }
    }

    ///  Test forecast contains data except day and hour forecasts.
    func testBasicJSON() {
        var forecast: Forecast?
        do {
            forecast = try builder?.parseJSONForecast(ForecastIOBuilderTests.basicJSON as? JSONDictionary)
            XCTAssertEqual(ForecastIOBuilderTests.testLatitude,  forecast?.latitude)
            XCTAssertEqual(ForecastIOBuilderTests.testLongitude, forecast?.longitude)
            XCTAssertEqual(ForecastIOBuilderTests.testUnitsTemperature, forecast?.units.temperature)
            XCTAssertNil(forecast?.currentConditions)
            XCTAssertNil(forecast?.oneHourForecasts)
            XCTAssertNil(forecast?.oneDayForecasts)
        } catch {
            XCTAssert(false, "basicJSON should not throw an error.")
        }
    }
}

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

    static let emptyJSON: JSONDictionary     = JSONDictionary()
    static let basicJSON: JSONDictionary     = ["latitude": testLatitude, "longitude": testLongitude, "units": testUnits]
    static let currentJSON: JSONDictionary   = ["currently": ["time": 1_400_000_000, "icon": "rain", "summary": "rain", "temperature": 15.4]]
    static let invalidIconJSON: JSONDictionary   = ["currently": ["time": 1_400_000_000, "icon": "xx", "summary": "rain", "temperature": 15.4]]
    static let missingIconJSON: JSONDictionary   = ["currently": ["time": 1_400_000_000, "summary": "rain", "temperature": 15.4]]
    static let noCurrentJSON: JSONDictionary = ["latitude": testLatitude, "currently": []]
    static let hoursJSON: JSONDictionary     = ["latitude": testLatitude, "hourly": ["data": [["time": 1_400_000_000, "icon": "rain", "summary": "rain", "temperature": 15.4]]]]
    static let noHoursJSON: JSONDictionary   = ["latitude": testLatitude, "hourly": []]
    static let badHoursJSON: JSONDictionary   = ["latitude": testLatitude, "hourly": ["data": [["fruit": "banana"]]]]
    static let daysJSON: JSONDictionary      = ["latitude": testLatitude, "daily": ["data": [["time": 1_401_000_000, "sunrise": 1_401_007_200, "sunset": 1_401_014_400]]]]
    static let noDaysJSON: JSONDictionary    = ["latitude": testLatitude, "daily": []]
    static let badDaysJSON: JSONDictionary    = ["latitude": testLatitude, "daily": ["data": [["fruit": "banana"]]]]
    static let flagsJSON: JSONDictionary     = ["latitude": testLatitude, "flags": ["units": "us"]]
    static let noFlagsJSON: JSONDictionary   = ["latitude": testLatitude, "flags": []]
    static let zzFlagsJSON: JSONDictionary   = ["latitude": testLatitude, "flags": ["units": "zz"]]

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
            XCTAssert(false, "nilJSON test should throw an error.")
        } catch ForecastParsingError.NilForecastSupplied {
            XCTAssert(true)
        } catch {
            XCTAssert(false, "nilJSON should throw a specific error.")
        }
    }

    ///  Test forecast not nil but contains no data.
    func testParseEmptyJSON() {
        var forecast: Forecast?
        do {
            forecast = try builder?.parseJSONForecast(ForecastIOBuilderTests.emptyJSON)
            XCTAssertNil(forecast)
            XCTAssert(false, "emptyJSON test should throw an error.")
        } catch ForecastParsingError.EmptyForecastSupplied {
            XCTAssert(true)
        } catch {
            XCTAssert(false, "emptyJSON should throw a specific error.")
        }
    }

    ///  Test forecast contains data except day and hour forecasts.
    func testBasicJSON() {
        var forecast: Forecast?
        do {
            forecast = try builder?.parseJSONForecast(ForecastIOBuilderTests.basicJSON)
            XCTAssertEqual(ForecastIOBuilderTests.testLatitude,  forecast?.latitude)
            XCTAssertEqual(ForecastIOBuilderTests.testLongitude, forecast?.longitude)
            XCTAssertEqual(ForecastIOBuilderTests.testUnitsTemperature, forecast?.units.temperature)
            XCTAssertNil(forecast?.currentConditions)
            XCTAssertNil(forecast?.oneHourForecasts)
            XCTAssertNil(forecast?.oneDayForecasts)
        } catch {
            XCTAssert(false, "basicJSON test should not throw an error.")
        }
    }

    ///  Test forecast contains current conditions.
    func testCurrentConditionsJSON() {
        var forecast: Forecast?
        do {
            forecast = try builder?.parseJSONForecast(ForecastIOBuilderTests.currentJSON)
            XCTAssertNotNil(forecast?.currentConditions)
            XCTAssertEqual(1_400_000_000, forecast?.currentConditions?.unixTime)
            XCTAssertEqual("rain", forecast?.currentConditions?.icon)
            XCTAssertEqual("rain", forecast?.currentConditions?.summary)
            XCTAssertEqual(15.4, forecast?.currentConditions?.temperature)
        } catch {
            XCTAssert(false, "currentJSON test should not throw an error.")
        }
    }

    ///  Test forecast contains current conditions.
    func testEmptyConditionsJSON() {
        var forecast: Forecast?
        do {
            forecast = try builder?.parseJSONForecast(ForecastIOBuilderTests.noCurrentJSON)
            XCTAssertNil(forecast?.currentConditions)
            XCTAssertNil(forecast?.currentConditions?.unixTime)
            XCTAssertNil(forecast?.currentConditions?.icon)
            XCTAssertNil(forecast?.currentConditions?.summary)
            XCTAssertNil(forecast?.currentConditions?.temperature)
        } catch {
            XCTAssert(false, "currentJSON test should not throw an error.")
        }
    }

    ///  Test forecast contains current conditions.
    func testInvalidIconJSON() {
        var forecast: Forecast?
        do {
            forecast = try builder?.parseJSONForecast(ForecastIOBuilderTests.invalidIconJSON)
            XCTAssertNotNil(forecast?.currentConditions)
            XCTAssertEqual("sun", forecast?.currentConditions?.icon)
        } catch {
            XCTAssert(false, "currentJSON test should not throw an error.")
        }
    }

    ///  Test forecast contains current conditions.
    func testMissingIconJSON() {
        var forecast: Forecast?
        do {
            forecast = try builder?.parseJSONForecast(ForecastIOBuilderTests.missingIconJSON)
            XCTAssertNotNil(forecast?.currentConditions)
            XCTAssertNil(forecast?.currentConditions?.icon)
        } catch {
            XCTAssert(false, "currentJSON test should not throw an error.")
        }
    }

    ///  Test forecast contains hourly forecasts.
    func testHourlyForecastsJSON() {
        var forecast: Forecast?
        do {
            forecast = try builder?.parseJSONForecast(ForecastIOBuilderTests.hoursJSON)
            XCTAssertNotNil(forecast?.oneHourForecasts)
            XCTAssertEqual(1_400_000_000, forecast?.oneHourForecasts?[0].unixTime)
            XCTAssertEqual("rain", forecast?.oneHourForecasts?[0].icon)
            XCTAssertEqual("rain", forecast?.oneHourForecasts?[0].summary)
            XCTAssertEqual(15.4, forecast?.oneHourForecasts?[0].temperature)
        } catch {
            XCTAssert(false, "hourlyJSON test should not throw an error.")
        }
    }

    ///  Test forecast contains hourly forecasts but nothing in them.
    func testNoHourlyForecastsJSON() {
        var forecast: Forecast?
        do {
            forecast = try builder?.parseJSONForecast(ForecastIOBuilderTests.noHoursJSON)
            XCTAssertNil(forecast?.oneHourForecasts)
        } catch {
            XCTAssert(false, "noHourlyJSON test should not throw an error.")
        }
    }

    ///  Test forecast contains hourly forecasts but nothing in them.
    func testBadHourlyForecastsJSON() {
        var forecast: Forecast?
        do {
            forecast = try builder?.parseJSONForecast(ForecastIOBuilderTests.badHoursJSON)
            XCTAssertNil(forecast?.oneHourForecasts)
        } catch {
            XCTAssert(false, "badHoursJSON test should not throw an error.")
        }
    }

    ///  Test forecast contains daily forecasts.
    func testDailyForecastsJSON() {
        var forecast: Forecast?
        do {
            forecast = try builder?.parseJSONForecast(ForecastIOBuilderTests.daysJSON)
            XCTAssertNotNil(forecast?.oneDayForecasts)
            XCTAssertEqual(1_401_000_000, forecast?.oneDayForecasts?[0].unixTime)
            XCTAssertEqual(1_401_007_200, forecast?.oneDayForecasts?[0].sunriseTime)
            XCTAssertEqual(1_401_014_400, forecast?.oneDayForecasts?[0].sunsetTime)
        } catch {
            XCTAssert(false, "dailyJSON test should not throw an error.")
        }
    }

    ///  Test forecast contains daily forecasts but nothing in them.
    func testNoDailyForecastsJSON() {
        var forecast: Forecast?
        do {
            forecast = try builder?.parseJSONForecast(ForecastIOBuilderTests.noDaysJSON)
            XCTAssertNil(forecast?.oneDayForecasts)
        } catch {
            XCTAssert(false, "noDailyJSON test should not throw an error.")
        }
    }

    ///  Test forecast contains daily forecasts but no readable data in them.
    func testBadDailyForecastsJSON() {
        var forecast: Forecast?
        do {
            forecast = try builder?.parseJSONForecast(ForecastIOBuilderTests.badDaysJSON)
            XCTAssertNil(forecast?.oneDayForecasts)
        } catch {
            XCTAssert(false, "noDailyJSON test should not throw an error.")
        }
    }

    ///  Test forecast contains flags.
    func testFlagsJSON() {
        var forecast: Forecast?
        do {
            forecast = try builder?.parseJSONForecast(ForecastIOBuilderTests.flagsJSON)
            XCTAssertNotNil(forecast?.units)
            XCTAssertEqual("°F", forecast?.units.temperature)
            XCTAssertEqual("mph", forecast?.units.windSpeed)
        } catch {
            XCTAssert(false, "flagsJSON test should not throw an error.")
        }
    }
    

    ///  Test forecast that contains unknown flags.  (Defaults to metric.)
    func testZZFlagsJSON() {
        var forecast: Forecast?
        do {
            forecast = try builder?.parseJSONForecast(ForecastIOBuilderTests.zzFlagsJSON)
            XCTAssertNotNil(forecast?.units)
            XCTAssertEqual("°C", forecast?.units.temperature)
            XCTAssertEqual("m/s", forecast?.units.windSpeed)
        } catch {
            XCTAssert(false, "zzFlagsJSON test should not throw an error.")
        }
    }
    
    ///  Test forecast contains no flags.
    func testNoFlagsJSON() {
        var forecast: Forecast?
        do {
            forecast = try builder?.parseJSONForecast(ForecastIOBuilderTests.noFlagsJSON)
            XCTAssertNotNil(forecast?.units)
            XCTAssertEqual("°C", forecast?.units.temperature)
            XCTAssertEqual("m/s", forecast?.units.windSpeed)
        } catch {
            XCTAssert(false, "noFlagsJSON test should not throw an error.")
        }
    }
}

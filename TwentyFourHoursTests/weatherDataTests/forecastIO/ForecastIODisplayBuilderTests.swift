//
//  ForecastIODisplayBuilderTests.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 06/05/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation
import XCTest
@testable import TwentyFourHours

class ForecastIODisplayBuilderTests: XCTestCase {

    let d1 = OneDayForecast(unixTime: 1_400_000_000, sunriseTime: nil, sunsetTime: nil)
    let d2 = OneDayForecast(unixTime: 1_400_100_000, sunriseTime: nil, sunsetTime: nil)
    let d3 = OneDayForecast(unixTime: 1_400_200_000, sunriseTime: nil, sunsetTime: nil)

    let d1ss = OneDayForecast(unixTime: 1_400_000_000, sunriseTime: 1_400_001_000, sunsetTime: 1_400_002_000)
    let d2ss = OneDayForecast(unixTime: 1_400_100_000, sunriseTime: 1_400_101_000, sunsetTime: 1_400_102_000)
    let d3ss = OneDayForecast(unixTime: 1_400_200_000, sunriseTime: 1_400_201_000, sunsetTime: 1_400_202_000)
    var threeDays: [OneDayForecast]?
    var threeDaysSunny: [OneDayForecast]?
    var fourHours: [OneHourForecast]?

    let h1 = OneHourForecast(unixTime: 1_400_000_000, icon: nil, summary: nil, temperature: nil)
    let h2 = OneHourForecast(unixTime: 1_400_003_600, icon: nil, summary: nil, temperature: nil)
    let h3 = OneHourForecast(unixTime: 1_400_007_200, icon: nil, summary: nil, temperature: nil)
    let h4 = OneHourForecast(unixTime: 1_400_010_800, icon: nil, summary: nil, temperature: nil)

    var emptyBuilder: ForecastIODisplayBuilder?

    ///   Runs before *each* test.
    override func setUp() {
        emptyBuilder = ForecastIODisplayBuilder(forecast: Forecast.emptyForecast)
        threeDays = [d1, d2, d3]
        threeDaysSunny = [d1ss, d2ss, d3ss]
        fourHours = [h1, h2, h3, h4]
    }

    override func tearDown() {
        emptyBuilder = nil
        threeDays = nil
        fourHours = nil
    }

    func testCreateable() {
        XCTAssertNotNil(emptyBuilder)
    }

    func testNoDays() {
        let dayLines = emptyBuilder?.dailyLines
        XCTAssertEqual(0, dayLines?.count)
    }

    func testNoHours() {
        let hourLines = emptyBuilder?.hourlyLines
        XCTAssertEqual(0, hourLines?.count)
    }

    func testThreeDays() {
        // Set up test.
        let threeDayForecast = Forecast(latitude: 51.3, longitude: -1.0, units: nil, currentConditions: nil, oneDayForecasts: threeDays, oneHourForecasts: nil)

        // Perform action.
        let dayLines = ForecastIODisplayBuilder(forecast: threeDayForecast).dailyLines

        // Check result.
        XCTAssertEqual(3, dayLines.count)
    }

    func testFourHoursNoDays() {
        // Set up test.
        let fourHourForecast = Forecast(latitude: 51.3, longitude: -1.0, units: nil, currentConditions: nil, oneDayForecasts: nil, oneHourForecasts: fourHours)

        // Perform action.
        let hourLines = ForecastIODisplayBuilder(forecast: fourHourForecast).hourlyLines

        // Check result.
        XCTAssertEqual(0, hourLines.count)
    }

    func testFourHoursThreeDaysWithoutSun() {
        // Set up test.
        let fourHourForecast = Forecast(latitude: 51.3, longitude: -1.0, units: nil, currentConditions: nil, oneDayForecasts: threeDays, oneHourForecasts: fourHours)

        // Perform action.
        let hourLines = ForecastIODisplayBuilder(forecast: fourHourForecast).hourlyLines

        // Check result.
        XCTAssertEqual(4, hourLines.count)
    }

    func testFourHoursThreeDaysWithSun() {
        // Set up test.
        let fourHourForecast = Forecast(latitude: 51.3, longitude: -1.0, units: nil, currentConditions: nil, oneDayForecasts: threeDaysSunny, oneHourForecasts: fourHours)

        // Perform action.
        let hourLines = ForecastIODisplayBuilder(forecast: fourHourForecast).hourlyLines

        // Check result.
        XCTAssertEqual(10, hourLines.count)
    }

    func testFourHoursThreeDaysWithSunSortOrder() {
        // Set up test.
        let fourHourForecast = Forecast(latitude: 51.3, longitude: -1.0, units: nil, currentConditions: nil, oneDayForecasts: threeDaysSunny, oneHourForecasts: fourHours)

        // Perform action.
        let hourLines = ForecastIODisplayBuilder(forecast: fourHourForecast).hourlyLines

        // Check result.
        for index in 1..<hourLines.count {
            let timeDifference = hourLines[index - 1].time.compare(hourLines[index].time)
            XCTAssertTrue(timeDifference != NSComparisonResult.OrderedDescending)
        }
    }
}

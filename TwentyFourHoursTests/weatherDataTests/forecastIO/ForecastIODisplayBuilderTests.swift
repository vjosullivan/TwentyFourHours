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

    let d1 = OneDayForecast(unixTime: 1_462_622_000, sunriseTime: nil, sunsetTime: nil)
    let d2 = OneDayForecast(unixTime: 1_462_708_400, sunriseTime: nil, sunsetTime: nil)
    let d3 = OneDayForecast(unixTime: 1_462_794_800, sunriseTime: nil, sunsetTime: nil)

    let d1ss = OneDayForecast(unixTime: 1_462_662_000, sunriseTime: 1_462_698_123, sunsetTime: 1_462_728_321)
    let d2ss = OneDayForecast(unixTime: 1_462_748_400, sunriseTime: 1_462_752_222, sunsetTime: 1_462_780_444)
    let d3ss = OneDayForecast(unixTime: 1_462_834_800, sunriseTime: 1_462_872_000, sunsetTime: 1_462_900_000)
    var threeDays: [OneDayForecast]?
    var threeDaysSunny: [OneDayForecast]?
    var fourHours: [OneHourForecast]?
    var sixHours: [OneHourForecast]?

    let h1 = OneHourForecast(unixTime: 1_400_000_000, icon: nil, summary: nil, temperature: nil)
    let h2 = OneHourForecast(unixTime: 1_400_003_600, icon: nil, summary: nil, temperature: nil)
    let h3 = OneHourForecast(unixTime: 1_400_007_200, icon: nil, summary: nil, temperature: nil)
    let h4 = OneHourForecast(unixTime: 1_400_010_800, icon: nil, summary: nil, temperature: nil)

    let d1h1 = OneHourForecast(unixTime: 1_462_662_000, icon: nil, summary: nil, temperature: nil)
    let d1h2 = OneHourForecast(unixTime: 1_462_665_600, icon: nil, summary: nil, temperature: nil)
    let d1h3 = OneHourForecast(unixTime: 1_462_669_200, icon: nil, summary: nil, temperature: nil)
    let d2h1 = OneHourForecast(unixTime: 1_462_748_400, icon: nil, summary: nil, temperature: nil)
    let d2h2 = OneHourForecast(unixTime: 1_462_778_000, icon: nil, summary: nil, temperature: nil)
    let d3h1 = OneHourForecast(unixTime: 1_462_834_800, icon: nil, summary: nil, temperature: nil)

    var emptyBuilder: ForecastIODisplayBuilder?

    ///   Runs before *each* test.
    override func setUp() {
        emptyBuilder = ForecastIODisplayBuilder(forecast: Forecast.emptyForecast)
        threeDays = [d1, d2, d3]
        threeDaysSunny = [d1ss, d2ss, d3ss]
        fourHours = [h1, h2, h3, h4]
        sixHours = [d1h1, d1h2, d1h3, d2h1, d2h2, d3h1]
    }

    override func tearDown() {
        emptyBuilder = nil
        threeDays = nil
        fourHours = nil
        sixHours  = nil
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
        XCTAssertEqual(3, hourLines.count)
    }

    func testFourHoursThreeDaysWithSun() {
        // Set up test.
        let forecast = Forecast(latitude: 51.3, longitude: -1.0, units: nil, currentConditions: nil, oneDayForecasts: threeDaysSunny, oneHourForecasts: sixHours)

        // Perform action.
        let hourLines = ForecastIODisplayBuilder(forecast: forecast).hourlyLines

        // Check result.
        XCTAssertEqual(3, hourLines.count)
        XCTAssertEqual(5, hourLines[0].count)
        XCTAssertEqual(4, hourLines[1].count)
        XCTAssertEqual(3, hourLines[2].count)
        print("H1 \(hourLines[0])")
        print("H2 \(hourLines[1])")
        print("H3 \(hourLines[2])")
    }
}

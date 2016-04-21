//
//  WeatherDataSourceTests.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 17/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import XCTest
import UIKit
@testable import TwentyFourHours

class WeatherDataSourceTests: XCTestCase {

    let expectedTemperature = 12.0
    /// This forecast contains no one-hour forecasts
    let mockEmptyForecast = Forecast(latitude: 0.0, longitude: 0.0, currentConditions: nil, oneDayForecasts: nil,
                                     oneHourForecasts: nil, timezone: nil, offset: nil, units: Units(units: "si"), lines: nil)

    var mockForecast: Forecast?
    var weatherDS: WeatherDataSource?
    var mockTableView = UITableView(frame: CGRectZero)

    override func setUp() {
        super.setUp()

        // Create a weather forecast containg one one-hour forecast.
        var forecasts = [OneHourForecast]()
        let oneForecast = OneHourForecast(icon: "icon", summary: "rain", temperature: expectedTemperature, time: 1)
        forecasts.append(oneForecast)
        mockForecast = Forecast(
            latitude: 51.3,
            longitude: -1.0,
            currentConditions: nil,
            oneDayForecasts: nil,
            oneHourForecasts: forecasts,
            timezone: nil,
            offset: nil,
            units: Units(units: "si"),
            lines: nil)

        // Add the forecast to the data source and make that the table's data source.
        weatherDS = WeatherDataSource(forecast: mockForecast!)
        mockTableView = UITableView(frame: CGRectZero)
        mockTableView.dataSource = weatherDS
        mockTableView.registerClass(mockWeatherTableViewCell.self, forCellReuseIdentifier: "HourCell")
    }
    
    override func tearDown() {
        weatherDS = nil
        mockForecast = nil
        super.tearDown()
    }
    
    func testCreatable() {
        XCTAssertNotNil(weatherDS)
    }

    func testSectionCount() {
        XCTAssertEqual(1, weatherDS?.numberOfSectionsInTableView(mockTableView))
    }

    func testRowCountWithForecast() {
        XCTAssertEqual(1, weatherDS?.tableView(mockTableView, numberOfRowsInSection: 0))
    }

    func testRowCountWithoutForecast() {
        weatherDS = WeatherDataSource(forecast: mockEmptyForecast)
        mockTableView = UITableView(frame: CGRectZero)
        mockTableView.dataSource = weatherDS
        mockTableView.registerClass(mockWeatherTableViewCell.self, forCellReuseIdentifier: "HourCell")
        XCTAssertEqual(0, weatherDS?.tableView(mockTableView, numberOfRowsInSection: 0))
    }

    func testCellPopulating() {
        let ip = NSIndexPath(forRow: 0, inSection: 0)
        let cell = weatherDS?.tableView(mockTableView, cellForRowAtIndexPath: ip) as? mockWeatherTableViewCell

        XCTAssertEqual(Int(expectedTemperature), Int((cell?.tempLabel.text)!))
    }
}
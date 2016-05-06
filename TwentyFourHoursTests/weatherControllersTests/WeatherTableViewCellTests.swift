//
//  WeatherTableViewCellTests.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 22/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import TwentyFourHours

class WeatherTableViewCellTests: XCTestCase {

    func testCreatable() {
        let cell = WeatherTableViewCell(frame: CGRectZero)
        XCTAssertNotNil(cell)
    }

    func testConfigureWithNoForecast() {
        let forecast = Forecast(
            latitude: nil,
            longitude: nil,
            units: nil,
            currentConditions: nil,
            oneDayForecasts: nil,
            oneHourForecasts: nil)
        let cell = WeatherTableViewCell(frame: CGRectZero)
        cell.tempLabel = UILabel(frame: CGRectZero)
        cell.configure(rowIndex: 0, forecast: forecast)

        // Check result: No forecast, no text.
        XCTAssertNil(cell.tempLabel.text)
    }

    func testConfigureWithEmptyHourForecast() {
        let forecast = Forecast(
            latitude: nil,
            longitude: nil,
            units: nil,
            currentConditions: nil,
            oneDayForecasts: nil,
            oneHourForecasts: [OneHourForecast(unixTime: nil, icon: "unknown", summary: nil, temperature: nil)])
        let cell = WeatherTableViewCell(frame: CGRectZero)
        cell.tempLabel = UILabel(frame: CGRectZero)
        cell.rainLabel = UILabel(frame: CGRectZero)
        cell.CFLabel = UILabel(frame: CGRectZero)
        cell.minsLabel = UILabel(frame: CGRectZero)
        cell.dayLabel = UILabel(frame: CGRectZero)
        cell.timeLabel = UILabel(frame: CGRectZero)
        cell.weatherIcon = UIImageView(image: UIImage(named: "sun"))
        cell.configure(rowIndex: 0, forecast: forecast)

        XCTAssertEqual("?", cell.tempLabel.text)
    }

    func testWeatherImageGood() {
        let forecast = Forecast(
            latitude: nil,
            longitude: nil,
            units: nil,
            currentConditions: nil,
            oneDayForecasts: nil,
            oneHourForecasts: [OneHourForecast(unixTime: nil, icon: "rain", summary: nil, temperature: nil)])
        let cell = WeatherTableViewCell(frame: CGRectZero)
        cell.tempLabel = UILabel(frame: CGRectZero)
        cell.rainLabel = UILabel(frame: CGRectZero)
        cell.CFLabel = UILabel(frame: CGRectZero)
        cell.minsLabel = UILabel(frame: CGRectZero)
        cell.dayLabel = UILabel(frame: CGRectZero)
        cell.timeLabel = UILabel(frame: CGRectZero)
        cell.weatherIcon = UIImageView(image: UIImage(named: "snow"))
        cell.configure(rowIndex: 0, forecast: forecast)

        let expectedIcon = UIImage(named: "rain")
        XCTAssertEqual(expectedIcon, cell.weatherIcon.image)
    }

    func testWeatherImageBad() {
        let forecast = Forecast(
            latitude: nil,
            longitude: nil,
            units: nil,
            currentConditions: nil,
            oneDayForecasts: nil,
            oneHourForecasts: [OneHourForecast(unixTime: nil, icon: "banana", summary: nil, temperature: nil)])
        let cell = WeatherTableViewCell(frame: CGRectZero)
        cell.tempLabel = UILabel(frame: CGRectZero)
        cell.rainLabel = UILabel(frame: CGRectZero)
        cell.CFLabel = UILabel(frame: CGRectZero)
        cell.minsLabel = UILabel(frame: CGRectZero)
        cell.dayLabel = UILabel(frame: CGRectZero)
        cell.timeLabel = UILabel(frame: CGRectZero)
        cell.weatherIcon = UIImageView(image: UIImage(named: "snow"))
        cell.configure(rowIndex: 0, forecast: forecast)

        let expectedIcon = UIImage(named: "sun")
        XCTAssertEqual(expectedIcon, cell.weatherIcon.image)
    }
}

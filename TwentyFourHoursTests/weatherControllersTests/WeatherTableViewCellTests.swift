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

    let datapointNil = DataPoint(unixTime: 0, icon: nil, summary: nil, temperature: nil, precipitationIntensity: nil, precipitationProbability: nil, precipitationType: nil, units: nil)

    var cell: WeatherTableViewCell?

    override func setUp() {
        cell = WeatherTableViewCell(frame: CGRectZero)
        cell!.tempLabel = UILabel(frame: CGRectZero)
        cell!.rainLabel = UILabel(frame: CGRectZero)
        cell!.CFLabel = UILabel(frame: CGRectZero)
        cell!.minsLabel = UILabel(frame: CGRectZero)
        cell!.timeLabel = UILabel(frame: CGRectZero)
        cell!.weatherIcon = UIImageView(image: UIImage(named: "unknown"))
    }

    override func tearDown() {
        cell     = nil
    }

    func testCreatable() {
        XCTAssertNotNil(cell)
    }

    func testConfigureWithNoSnapshot() {
        cell!.tempLabel = UILabel(frame: CGRectZero)
        cell!.configure(datapointNil)

        // Check result: No forecast, no text.
        XCTAssertEqual("", cell!.tempLabel.text)
    }

    func testConfigureWithEmptyHourForecast() {
        cell!.configure(datapointNil)

        XCTAssertEqual("", cell!.tempLabel.text)
    }

    func testWeatherImageGood() {
        let datapointGoodIcon = DataPoint(unixTime: 0, icon: "snow", summary: nil, temperature: nil, precipitationIntensity: nil, precipitationProbability: nil, precipitationType: nil, units: nil)
        cell!.configure(datapointGoodIcon)

        let expectedIcon = UIImage(named: "snow")
        XCTAssertEqual(expectedIcon, cell!.weatherIcon.image)
    }

    func testWeatherImageBad() {
        let datapointBadIcon = DataPoint(unixTime: 0, icon: "BANANA", summary: nil, temperature: nil, precipitationIntensity: nil, precipitationProbability: nil, precipitationType: nil, units: nil)
        cell!.configure(datapointBadIcon)

        let expectedIcon = UIImage(named: "unknown")
        XCTAssertEqual(expectedIcon, cell!.weatherIcon.image)
    }

    func testDayFromUnixTime() {

        let unixTime = 946728000.0
        XCTAssertEqual("Sa", cell!.dayStringFromUnixTime(unixTime))
    }
}

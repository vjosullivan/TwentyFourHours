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

    let snapshotNil = WeatherSnapshot(unixTime: nil, icon: nil, summary: nil, temperature: nil, units: nil)

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
        cell!.configure(snapshotNil)

        // Check result: No forecast, no text.
        XCTAssertEqual("", cell!.tempLabel.text)
    }

    func testConfigureWithEmptyHourForecast() {
        cell!.configure(snapshotNil)

        XCTAssertEqual("", cell!.tempLabel.text)
    }

    func testWeatherImageGood() {
        let snapshotGoodIcon = WeatherSnapshot(unixTime: nil, icon: "snow", summary: nil, temperature: nil, units: nil)
        cell!.configure(snapshotGoodIcon)

        let expectedIcon = UIImage(named: "snow")
        XCTAssertEqual(expectedIcon, cell!.weatherIcon.image)
    }

    func testWeatherImageBad() {
        let snapshotBadIcon = WeatherSnapshot(unixTime: nil, icon: "BANANA", summary: nil, temperature: nil, units: nil)
        cell!.configure(snapshotBadIcon)

        let expectedIcon = UIImage(named: "unknown")
        XCTAssertEqual(expectedIcon, cell!.weatherIcon.image)
    }
}

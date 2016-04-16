//
//  UnitsTests.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 16/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import TwentyFourHours

class UnitsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testCreatable() {
        let testUnits = "test"
        let units = Units(units: testUnits)
        XCTAssertNotNil(units)
    }

    func testTemperatureSI() {
        let testUnits = "si"
        let units = Units(units: testUnits)
        XCTAssertEqual("°C", units.temperature)
    }

    func testTemperatureUS() {
        let testUnits = "us"
        let units = Units(units: testUnits)
        XCTAssertEqual("°F", units.temperature)
    }

    func testTemperatureUnknown() {
        let testUnits = "xx"
        let units = Units(units: testUnits)
        XCTAssertEqual("°C", units.temperature)
    }

    func testWindSpeedSI() {
        let testUnits = "si"
        let units = Units(units: testUnits)
        XCTAssertEqual("m/s", units.windSpeed)
    }
}

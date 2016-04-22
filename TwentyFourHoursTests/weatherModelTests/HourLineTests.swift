//
//  HourLineTests.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 21/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import TwentyFourHours

class HourLineTests: XCTestCase {

    func testCreatable() {
        let line = HourLine(time: NSDate(), temperature: 99.0, units: "C", summary: "Sunny", icon: "")
        XCTAssertNotNil(line)
        XCTAssertEqual("Sunny", line.text())
    }
}
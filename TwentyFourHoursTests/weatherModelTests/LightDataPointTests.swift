//
//  LightDataPointTests.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 11/06/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import TwentyFourHours

class LightDataPointTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCreatable() {
        let point = LightDataPoint(unixTime: 123, icon: "unknown", summary: "test summary")
        XCTAssertNotNil(point)
        XCTAssertEqual(123, point.unixTime)
        XCTAssertEqual("unknown", point.icon)
        XCTAssertEqual("test summary", point.summary)
        XCTAssertNil(point.temperature)
        XCTAssertNil(point.units)
    }
}

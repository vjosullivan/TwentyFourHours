//
//  FlagsTests.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 16/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import XCTest

class FlagsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testCreatable() {
        let testUnits = "Auto"
        let flags = Flags(units: testUnits)
        XCTAssertNotNil(flags)
        XCTAssertEqual(testUnits, flags.units)
    }

    func testNoUnits() {
        let testUnits: String? = nil
        let flags = Flags(units: testUnits)
        XCTAssertNotNil(flags)
        XCTAssertNil(flags.units)
    }
}

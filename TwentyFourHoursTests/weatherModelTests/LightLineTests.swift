//
//  LightLineTests.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 21/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import TwentyFourHours

class LightLineTests: XCTestCase {

    func testCreatable() {
        let line = LightLine(time: NSDate(), twilightType: .Sunrise)
        XCTAssertNotNil(line)
    }

    func testDisplayedText() {
        let line1 = LightLine(time: NSDate(), twilightType: .Sunrise)
        let line2 = LightLine(time: NSDate(), twilightType: .Sunset)
        XCTAssertEqual(TwilightType.Sunrise.rawValue, line1.text)
        XCTAssertEqual(TwilightType.Sunset.rawValue, line2.text)
    }
}

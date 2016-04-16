//
//  UserDefaultsExtensionTests.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 16/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import TwentyFourHours

class UserDefaultsExtensionTests: XCTestCase {

    func testWriteAndReadString() {
        let testKey   = "24H.unitTest"
        let testValue = "testString"
        NSUserDefaults.write(key: testKey, value: testValue)
        XCTAssertEqual(testValue, NSUserDefaults.read(key: testKey, defaultValue: "X"))
    }

    func testWriteAndReadDefaultString() {
        let testKey   = "24H.unitTest"
        let testValue = "testString"
        NSUserDefaults.write(key: testKey, value: testValue)
        XCTAssertEqual("DEFAULT", NSUserDefaults.read(key: "badKey", defaultValue: "DEFAULT"))
    }

    func testWriteAndReadInt() {
        let testKey   = "24H.unitTest"
        let testValue = 100
        NSUserDefaults.writeInt(key: testKey, value: testValue)
        XCTAssertEqual(testValue, NSUserDefaults.readInt(key: testKey, defaultValue: 99))
    }

    func testWriteAndReadDefaultInt() {
        let testKey   = "24H.unitTest"
        let testValue = 100
        NSUserDefaults.writeInt(key: testKey, value: testValue)
        XCTAssertEqual(99, NSUserDefaults.readInt(key: "badKey", defaultValue: 99))
    }
}

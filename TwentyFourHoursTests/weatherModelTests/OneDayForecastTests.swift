//
//  OneDayForecastTests.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 16/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import TwentyFourHours

class OneDayForecastTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testCreatable() {
        let odf = OneDayForecast(sunriseTime: nil, sunsetTime: nil, time: nil)
        XCTAssertNotNil(odf)
    }

    func testDescription() {
        let testTime    = NSDate(timeIntervalSinceReferenceDate: 1460723696) // 2016-04-15 12:34:56
        testTime.asYYYYMMDD()
        let testSunrise = NSDate(timeIntervalSinceReferenceDate: 1460705700) // 2016-04-15 07:35:00
        let testSunset  = NSDate(timeIntervalSinceReferenceDate: 1460754300) // 2016-04-15 21:05:00
        let odf = OneDayForecast(sunriseTime: testSunrise, sunsetTime: testSunset, time: testTime)
        let desc = odf.description

        XCTAssertTrue(desc.containsString(asYYYYMMDD(testTime)))
        XCTAssertTrue(desc.containsString(asHHMM(testTime)))
        XCTAssertTrue(desc.containsString(asHHMM(testSunrise)))
        XCTAssertTrue(desc.containsString(asHHMM(testSunset)))
    }

    func asYYYYMMDD(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.stringFromDate(date)
    }

    func asHHMM(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.stringFromDate(date)
    }

}

//
//  MockForecastManagerDelegate.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 05/05/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import TwentyFourHours

class MockForecastManagerDelegate: ForecastManagerDelegate {

    let expectation: XCTestExpectation
    var updateCallCount = 0
    var failCallCount   = 0

    init(expectation: XCTestExpectation) {
        self.expectation = expectation
    }

    func forecastManager(manager: ForecastIOManager, didUpdateForecast forecast: Forecast) {
        expectation.fulfill()
        print("\n\nExpectations fullfilled!!!\n\n")
        updateCallCount += 1
    }

    func forecastManager(manager: ForecastIOManager, didFailWithError error: NSError) {
        failCallCount += 1
    }
}

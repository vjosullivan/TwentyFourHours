//
//  LocationManagerTests.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 17/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import XCTest
import CoreLocation
@testable import TwentyFourHours

class LocationManagerTests: XCTestCase {
    
    func testCanCreate() {
        let mockDelegate = MockLocationManagerDelegate()
        let lm = LocationManager(delegate: mockDelegate)
        XCTAssertNotNil(lm)
    }

    func testSucessCallsDelegate() {
        let mockDelegate = MockLocationManagerDelegate()
        let lm = LocationManager(delegate: mockDelegate)

        var locations = [CLLocation]()
        let location = CLLocation(latitude: 51.3, longitude: -1.0)
        locations.append(location)
        lm.locationManager(lm, didUpdateLocations: locations)

        XCTAssertEqual(location.coordinate.latitude, mockDelegate.location?.latitude)
        XCTAssertEqual(location.coordinate.longitude, mockDelegate.location?.longitude)
    }

    func testFailureCallsDelegate() {
        let mockDelegate = MockLocationManagerDelegate()
        let lm = LocationManager(delegate: mockDelegate)

        let error = NSError(domain: "vos", code: 99, userInfo: nil)
        lm.locationManager(lm, didFailWithError: error)

        XCTAssertEqual(error.code, mockDelegate.error!.code)
    }
}

class MockLocationManagerDelegate: LocationManagerDelegate {

    var location: (latitude: Double, longitude: Double)?
    var error: NSError?

    func locationManager(manager: LocationManager, didUpdateLocation location: (latitude: Double, longitude: Double)) {
        print("MLMD Success")
        self.location = location
    }

    func locationManager(manager: LocationManager, didFailWithError error: NSError) {
        print("MLMD Fail.")
        self.error = error
    }
}

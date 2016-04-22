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

    var mockDelegate: MockLocationManagerDelegate?
    var locationManager: LocationManager?

    override func setUp() {
        super.setUp()
        mockDelegate = MockLocationManagerDelegate()
        locationManager = LocationManager(delegate: mockDelegate!)
    }
    
    override func tearDown() {
        locationManager = nil
        mockDelegate = nil
        super.tearDown()
    }

    func testCanCreate() {
        XCTAssertNotNil(locationManager!)
    }

    func testSucessCallsDelegate() {

        // Set up test.
        var locations = [CLLocation]()
        let location = CLLocation(latitude: 51.3, longitude: -1.0)
        locations.append(location)
        locationManager!.locationManager(locationManager!, didUpdateLocations: locations)

        // Check results.
        XCTAssertEqual(location.coordinate.latitude, mockDelegate!.location?.latitude)
        XCTAssertEqual(location.coordinate.longitude, mockDelegate!.location?.longitude)
    }

    func testFailureCallsDelegate() {
        let error = NSError(domain: "vos", code: 99, userInfo: nil)
        locationManager!.locationManager(locationManager!, didFailWithError: error)

        XCTAssertEqual(error.code, mockDelegate!.error!.code)
    }
}

class MockLocationManagerDelegate: LocationManagerDelegate {

    var location: (latitude: Double, longitude: Double)?
    var error: NSError?

    func locationManager(manager: LocationManager, didUpdateLocation location: (latitude: Double, longitude: Double)) {
        self.location = location
    }

    func locationManager(manager: LocationManager, didFailWithError error: NSError) {
        self.error = error
    }
}

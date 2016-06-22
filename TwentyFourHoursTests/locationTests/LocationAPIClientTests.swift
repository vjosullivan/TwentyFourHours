//
//  LocationAPIClientTests.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 17/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import XCTest
import CoreLocation
@testable import TwentyFourHours

class LocationAPIClientTests: XCTestCase {

    var mockDelegate: MockLocationAPIClientDelegate?
    var locationAPIClient: LocationAPIClient?

    override func setUp() {
        super.setUp()
        mockDelegate      = MockLocationAPIClientDelegate()
        locationAPIClient = LocationAPIClient(delegate: mockDelegate!)
    }
    
    override func tearDown() {
        locationAPIClient = nil
        mockDelegate = nil
        super.tearDown()
    }

    func testCanCreate() {
        XCTAssertNotNil(locationAPIClient!)
    }

    func testSucessCallsDelegate() {

        // Set up test.
        var locations = [CLLocation]()
        let location = CLLocation(latitude: 51.3, longitude: -1.0)
        locations.append(location)
        locationAPIClient!.locationManager(locationAPIClient!, didUpdateLocations: locations)

        // Check results.
        XCTAssertEqual(location.coordinate.latitude, mockDelegate!.location?.latitude)
        XCTAssertEqual(location.coordinate.longitude, mockDelegate!.location?.longitude)
    }

    func testFailureCallsDelegate() {
        let error = NSError(domain: "vos", code: 99, userInfo: nil)
        locationAPIClient!.locationManager(locationAPIClient!, didFailWithError: error)

        XCTAssertEqual(error.code, mockDelegate!.error!.code)
    }
}

class MockLocationAPIClientDelegate: LocationAPIClientDelegate {

    var location: (latitude: Double, longitude: Double)?
    var error: NSError?

    func location(client: LocationAPIClient, didUpdateLocation location: (latitude: Double, longitude: Double)) {
        self.location = location
    }

    func location(client: LocationAPIClient, didFailWithError error: NSError) {
        self.error = error
    }
}

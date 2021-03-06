//
//  LocationAPIClient.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 17/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit
import CoreLocation

class LocationAPIClient: CLLocationManager {

    let locationDelegate: LocationAPIClientDelegate

    init(delegate: LocationAPIClientDelegate) {
        self.locationDelegate = delegate
        super.init()
        requestAuthorization()
    }

    override func requestLocation() {

        if CLLocationManager.locationServicesEnabled() {
            delegate = self
            desiredAccuracy = kCLLocationAccuracyKilometer
            super.requestLocation()
        }
    }

    ///  Prompts the user to grant authozation for this application to
    ///  access the geographic location of the current device.
    ///
    private func requestAuthorization() {
        // Ask for Authorisation from the User.
        //requestAlwaysAuthorization()

        // For use in foreground
        requestWhenInUseAuthorization()
    }
}

extension LocationAPIClient: CLLocationManagerDelegate {

    func locationManager(_ client: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coords = locations[0].coordinate
        let location = (latitude: coords.latitude, longitude: coords.longitude)
        locationDelegate.location(client: self, didUpdateLocation: location)
    }

    func locationManager(_ client: CLLocationManager, didFailWithError error: NSError) {
        locationDelegate.location(client: self, didFailWithError: error)
    }
}

protocol LocationAPIClientDelegate {

    ///  Tells the delegate that new location information is available.
    ///
    ///  - parameter client:  The location API client that updated the location information.
    ///  - parameter location: The new location data.
    ///
    func location(client: LocationAPIClient, didUpdateLocation location: (latitude: Double, longitude: Double))

    ///  Tells the delegate that the location manager failed to obtain a location.
    ///
    ///  - parameter client: The location API client that failed.
    ///  - parameter error:   The nature of the error encountered.
    ///
    func location(client: LocationAPIClient, didFailWithError error: NSError)
}

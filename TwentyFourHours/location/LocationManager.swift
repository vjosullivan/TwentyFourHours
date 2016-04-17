//
//  LocationManager.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 17/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: CLLocationManager {

    let locationDelegate: LocationManagerDelegate

    init(delegate: LocationManagerDelegate) {
        self.locationDelegate = delegate
        super.init()
        configure()
    }

    override func requestLocation() {

        if CLLocationManager.locationServicesEnabled() {
            delegate = self
            desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            super.requestLocation()
        }
    }

    private func configure() {
        // Ask for Authorisation from the User.
        requestAlwaysAuthorization()

        // For use in foreground
        requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coords = locations[0].coordinate
        let location = (latitude: coords.latitude, longitude: coords.longitude)
        locationDelegate.locationManager(self, didUpdateLocation: location)
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        locationDelegate.locationManager(self, didFailWithError: error)
    }
}

protocol LocationManagerDelegate {

    func locationManager(manager: LocationManager, didUpdateLocation location: (latitude: Double, longitude: Double))

    func locationManager(manager: LocationManager, didFailWithError error: NSError)
}
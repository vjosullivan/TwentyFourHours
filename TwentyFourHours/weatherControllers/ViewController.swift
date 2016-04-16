//
//  ViewController.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 14/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate {

    // MARK: Properties

    private var forecast: Forecast?
    private var weatherData: WeatherDataSource?

    @IBOutlet weak var weatherTable: UITableView!

    // MARK: Location

    let locationManager = CLLocationManager()

    // MARK: Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        weatherTable.delegate = self
        weatherTable.dataSource = weatherData

        configureLocationManager()
        start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func start() {
        locationManager.requestLocation()
    }

    private func updateView(forecast: Forecast) {
        weatherData = WeatherDataSource(forecast: forecast)
        weatherTable.dataSource = weatherData
        weatherTable.reloadData()
    }
}

extension ViewController: CLLocationManagerDelegate {

    private func configureLocationManager() {
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()

        // For use in foreground
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            fetchWeather(location)
            let info = location
            let _ = NSTimer.scheduledTimerWithTimeInterval(900,
                                                           target:self,
                                                           selector: #selector(ViewController.fetchMoreWeather(_:)),
                                                           userInfo: info,
                                                           repeats: true)
            updateLocationLabel(location)
        } else {
            print("Unable to determine location.")
        }
    }

    func fetchMoreWeather(timer: NSTimer) {
        if let location = timer.userInfo as? CLLocation {
            fetchWeather(location)
        }
    }

    func fetchWeather(location: CLLocation) {
        let coords = location.coordinate
        let units = NSUserDefaults.read(key: WeatherKeys.units, defaultValue: "auto")
        ForecastIOManager().fetchWeather(latitude: coords.latitude, longitude: coords.longitude, units: units) {(data, error) in
            if let data = data {
                dispatch_async(dispatch_get_main_queue()) {
                    if let forecast = ForecastIOBuilder().buildForecast(data) {
                        print("Got weather!")
                        self.updateView(forecast)
                    } else {
                        let alertController = UIAlertController(title: "Current Weather", message: "No weather forecast available at the moment.", preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(okAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
            if let error = error {
                print("ERROR: \(error.description)")
            }
        }
    }

    private func updateLocationLabel(location: CLLocation) {
        print(location.description)
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("CLONK! \(error.description)")
    }
}

struct WeatherKeys {
    static let units    = "weather.units"
    static let windType = "weather.windtype"
}

enum CellStyle {
    case Day
    case Night
    case Evening
    case Dusk
}

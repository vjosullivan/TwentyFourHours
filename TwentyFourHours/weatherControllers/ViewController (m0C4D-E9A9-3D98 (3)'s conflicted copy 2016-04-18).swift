//
//  ViewController.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 14/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties

    private var forecast: Forecast?

    @IBOutlet weak var weatherTable: UITableView!
    // MARK: Location

    let locationManager = CLLocationManager()

    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weatherTable.delegate = self
        weatherTable.dataSource = self
        //weatherTable.registerClass(WeatherTableViewCell.self, forCellReuseIdentifier: "HourCell")

        configureLocationManager()
        locationManager.requestLocation()
    }

    private func updateView(forecast: Forecast) {
        self.forecast = forecast
        weatherTable.reloadData()
    }
}

extension ViewController: CLLocationManagerDelegate {

    private func configureLocationManager() {
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Wahey! \(manager.description)")
        if let location = manager.location {
            let timer = NSTimer.scheduledTimerWithTimeInterval(900,
                                                               target:self,
                                                               selector: #selector(fetchMoreWeather(_:)),
                                                               userInfo: location,
                                                               repeats: true)
            timer.fire()
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
        print("Fetching forecast at \(coords.latitude), \(coords.longitude) in \(units).  Altitude \(location.altitude)")
        ForecastIOManager().fetchWeather(latitude: coords.latitude, longitude: coords.longitude, units: units) {(data, error) in
            if let data = data {
                dispatch_async(dispatch_get_main_queue()) {
                    if let forecast = ForecastIOBuilder().buildForecast(data) {
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
//        let latitude  = round(location.coordinate.latitude * 10.0) / 10.0
//        let longitude = round(location.coordinate.longitude * 10.0) / 10.0
//        let altitude  = round(location.altitude * 10.0) / 10.0
//        let latitudeSuffix  = latitude >= 0.0 ? "°N" : "°S"
//        let longitudeSuffix = longitude >= 0.0 ? "°E" : "°W"
        print(location.description)
        //locationLine1.text = "\(abs(latitude))\(latitudeSuffix)  \(abs(longitude))\(longitudeSuffix)"
        //locationLine2.text = "altitude: \(altitude)m"
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("CLONK! \(error.description)")
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection = \(forecast?.oneHourForecasts!.count)")
        return forecast?.oneHourForecasts!.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HourCell")! as! WeatherTableViewCell
        if let forecast = forecast {
            cell.configure(indexPath.row, forecast: forecast)
        }
        return cell

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

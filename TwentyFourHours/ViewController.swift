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

        configureUI()
        configureLocationManager()
        fetchWeather()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func configureUI() {

    }

    private func fetchWeather() {
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

        // For use in foreground
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Wahey! \(manager.description)")
        if let coords = manager.location?.coordinate,
            let location = manager.location {
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
            updateLocationLabel(location)
        } else {
            print("Unable to determine location.")
        }
    }

    private func updateLocationLabel(location: CLLocation) {
        let latitude  = round(location.coordinate.latitude * 10.0) / 10.0
        let longitude = round(location.coordinate.longitude * 10.0) / 10.0
        let altitude  = round(location.altitude * 10.0) / 10.0
        let latitudeSuffix  = latitude >= 0.0 ? "°N" : "°S"
        let longitudeSuffix = longitude >= 0.0 ? "°E" : "°W"
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

        let temp = forecast?.oneHourForecasts?[indexPath.row].temperature ?? 0.0
        cell.tempLabel!.text = "\(round(temp * 10.0) / 10.0)"

        cell.timeLabel!.text = timeStringFromUnixTime(Double(forecast?.oneHourForecasts?[indexPath.row].time ?? 0.0))

        let precip    = Int(round((forecast?.oneHourForecasts?[indexPath.row].precipProbability ?? 0.0) * 100))
        let intensity = round((forecast?.oneHourForecasts?[indexPath.row].precipIntensity ?? 0.0))
        let rainType  = forecast?.oneHourForecasts?[indexPath.row].precipType ?? ""
        let summary  = forecast?.oneHourForecasts?[indexPath.row].summary ?? ""
        let icon  = forecast?.oneHourForecasts?[indexPath.row].icon ?? ""
        //cell.rainLabel!.text = "\(precip)% \(intensity) \(rainType) (\(icon)) \(summary)"
        cell.rainLabel!.text = "(\(icon)) \(summary)"
        return cell
    }

    func timeStringFromUnixTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "E HH:mm"
        return dateFormatter.stringFromDate(date)
    }
}

struct WeatherKeys {
    static let units    = "weather.units"
    static let windType = "weather.windtype"
}

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
        start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func configureUI() {

    }

    private func start() {
        locationManager.requestLocation()
    }

    private func updateView(forecast: Forecast) {
        self.forecast = forecast
        weatherTable.reloadData()
    }

    private func weatherImage(iconName: String?) -> UIImage {
        let image: UIImage
        if let iconName = iconName {
            switch iconName {
            case "clear-day":
                image = UIImage(named: "sun")!
            case "clear-night":
                image = UIImage(named: "moon")!
            case "rain":
                image = UIImage(named: "rain")!
            case "snow":
                image = UIImage(named: "snow")!
            case "sleet":
                image = UIImage(named: "sleet")!
            case "wind":
                image = UIImage(named: "wind")!
            case "fog":
                image = UIImage(named: "fog")!
            case "cloudy":
                image = UIImage(named: "cloudy")!
            case "partly-cloudy-day":
                image = UIImage(named: "partly cloudy day")!
            case "partly-cloudy-night":
                image = UIImage(named: "partly cloudy night")!
            case "hail":
                image = UIImage(named: "hail")!
            case "thunderstorm":
                image = UIImage(named: "thunderstorm")!
            case "tornado":
                image = UIImage(named: "tornado")!
            default:
                let alertController = UIAlertController(title: "Current Weather", message: "No icon found for weather condition: '\(iconName).\n\nHence the 'alien' face.", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(okAction)
                presentViewController(alertController, animated: true, completion: nil)
                image = UIImage(named: "sun.png")!
            }
        } else {
            let alertController = UIAlertController(title: "Current Weather", message: "No weather condition icon selector supplied by the forecast.  Hence the circle.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true, completion: nil)
            image = UIImage(named: "sun.png")!
        }
        return image
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
        print(location.description)
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
        cell.tempLabel!.text = "\(Int(round(temp)))"
        cell.CFLabel.text = Units(units: forecast?.flags?.units ?? "si").temperature

        cell.dayLabel!.text  =  dayStringFromUnixTime(Double(forecast?.oneHourForecasts?[indexPath.row].time ?? 0.0))
        cell.timeLabel!.text = timeStringFromUnixTime(Double(forecast?.oneHourForecasts?[indexPath.row].time ?? 0.0))

        let summary  = forecast?.oneHourForecasts?[indexPath.row].summary ?? ""
        let icon  = forecast?.oneHourForecasts?[indexPath.row].icon ?? ""

        cell.rainLabel!.text = "\(summary)"
        cell.weatherIcon.image = weatherImage(icon)

        let style = indexPath.row < 11
            ? CellStyle.Day
            : indexPath.row < 12
                ? CellStyle.Evening
                : indexPath.row < 13
                    ? CellStyle.Dusk
                    : CellStyle.Night
        setCellColours(cell, style: style)
        return cell
    }

    func setCellColours(cell: WeatherTableViewCell, style: CellStyle) {
        switch style {
        case .Day:
            cell.backgroundColor = UIColor.whiteColor()
            cell.dayLabel.textColor = UIColor.blackColor()
            cell.timeLabel.textColor = UIColor.blackColor()
            cell.minsLabel.textColor = UIColor.blackColor()
            cell.tempLabel.textColor = UIColor.blackColor()
            cell.CFLabel.textColor = UIColor.blackColor()
            cell.rainLabel.textColor = UIColor.blackColor()
        case .Evening:
            cell.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.6, alpha: 1.0)
            cell.dayLabel.textColor = UIColor.blackColor()
            cell.timeLabel.textColor = UIColor.blackColor()
            cell.minsLabel.textColor = UIColor.blackColor()
            cell.tempLabel.textColor = UIColor.blackColor()
            cell.CFLabel.textColor = UIColor.blackColor()
            cell.rainLabel.textColor = UIColor.blackColor()
        case .Dusk:
            cell.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 1.0)
            cell.dayLabel.textColor = UIColor.whiteColor()
            cell.timeLabel.textColor = UIColor.whiteColor()
            cell.minsLabel.textColor = UIColor.whiteColor()
            cell.tempLabel.textColor = UIColor.whiteColor()
            cell.CFLabel.textColor = UIColor.whiteColor()
            cell.rainLabel.textColor = UIColor.whiteColor()
        case .Night:
            cell.backgroundColor = UIColor.blackColor()
            cell.dayLabel.textColor = UIColor.whiteColor()
            cell.minsLabel.textColor = UIColor.whiteColor()
            cell.timeLabel.textColor = UIColor.whiteColor()
            cell.tempLabel.textColor = UIColor.whiteColor()
            cell.CFLabel.textColor = UIColor.whiteColor()
            cell.rainLabel.textColor = UIColor.whiteColor()
        }
    }

    func dayStringFromUnixTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEEEE"  // 2 letter day.
        return dateFormatter.stringFromDate(date)
    }

    func timeStringFromUnixTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH"
        return dateFormatter.stringFromDate(date)
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

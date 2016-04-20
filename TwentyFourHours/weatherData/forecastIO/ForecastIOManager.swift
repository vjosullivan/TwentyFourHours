//
//  WeatherManager.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

typealias Location = (latitude: Double, longitude: Double)

///  Handles communication with the weather API.
public class ForecastIOManager {
    
    // MARK: - Properties
    
    private let forecastApiKey = "7f7075d90bf85644daa070b898a10132"

    var locationManager: LocationManager?
    let forecastDelegate: ForecastManagerDelegate

    // MARK: - Methods

    init(delegate: ForecastManagerDelegate) {

        forecastDelegate = delegate
    }

    func updateForecast() {
        locationManager = LocationManager(delegate: self)
        locationManager?.requestLocation()
    }
    
    ///  Fetches the weather data and passes it to the supplied handler.
    ///
    private func fetchWeather(location location: Location) {

        let units = NSUserDefaults.read(key: WeatherKeys.units, defaultValue: "si")
        let session = NSURLSession.sharedSession()
        let weatherURL = forecastURL(location, units: units)
        let loadDataTask = session.dataTaskWithURL(weatherURL) { (data, response, error) -> Void in
            if let error = error {
                self.forecastDelegate.forecastManager(self, didFailWithError: error)
            } else if let response = response as? NSHTTPURLResponse {
                if response.statusCode != 200 {
                    let statusError = NSError(
                        domain: "com.vjosullivan",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    self.forecastDelegate.forecastManager(self, didFailWithError: statusError)
                } else {
                    self.forecastDelegate.forecastManager(self, didUpdateForecast: ForecastIOBuilder().buildForecast(data!)!)
                }
            }
        }
        loadDataTask.resume()
    }

    private func forecastURL(location: Location, units: String) -> NSURL {
        return NSURL(string: "https://api.forecast.io/forecast/\(forecastApiKey)/\(location.latitude),\(location.longitude)?units=\(units)")!
    }
}

extension ForecastIOManager: LocationManagerDelegate {

    func locationManager(manager: LocationManager, didUpdateLocation location: Location) {
        fetchWeather(location: location)
    }

    func locationManager(manager: LocationManager, didFailWithError error: NSError) {
        print("Location manager failed with error: \(error)")
    }
}

protocol ForecastManagerDelegate {

    func forecastManager(manager: ForecastIOManager, didUpdateForecast forecast: Forecast)

    func forecastManager(manager: ForecastIOManager, didFailWithError error: NSError)
}

struct WeatherKeys {
    static let units    = "weather.units"
    static let windType = "weather.windtype"
}

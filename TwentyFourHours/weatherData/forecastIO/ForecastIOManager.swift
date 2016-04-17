//
//  WeatherManager.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation


///  Handles communication with the weather API.
public class ForecastIOManager {
    
    // MARK: - Properties
    
    private let forecastApiKey = "7f7075d90bf85644daa070b898a10132"

    var locationManager: LocationManager?
    let forecastDelegate: ForecastManagerDelegate

    // MARK: - Methods

    init(delegate: ForecastManagerDelegate) {

        self.forecastDelegate = delegate
    }

    func updateForecast() {
        locationManager = LocationManager(delegate: self)
    }
    
    ///  Fetches the weather data and passes the results to the ForecastManager delegate.
    ///
    private func fetchWeather(location location: (latitude: Double, longitude: Double), delegate: ForecastManagerDelegate) {

        let units = NSUserDefaults.read(key: WeatherKeys.units, defaultValue: "si")
        let session = NSURLSession.sharedSession()
        let weatherURL = forecastURL(latitude: location.latitude, longitude: location.longitude, units: units)
        let loadDataTask = session.dataTaskWithURL(weatherURL) { (data, response, error) -> Void in
            if let error = error {
                delegate.forecastManager(self, didFailWithError: error)
            } else if let response = response as? NSHTTPURLResponse {
                if response.statusCode != 200 {
                    let statusError = NSError(
                        domain: "com.vjosullivan",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    delegate.forecastManager(self, didFailWithError: statusError)
                } else {
                    delegate.forecastManager(self, didUpdateForecast: ForecastIOBuilder().buildForecast(data!)!)
                }
            }
        }
        loadDataTask.resume()
    }

    private func forecastURL(latitude latitude: Double, longitude: Double, units: String) -> NSURL {
        return NSURL(string: "https://api.forecast.io/forecast/\(forecastApiKey)/\(latitude),\(longitude)?units=\(units)")!
    }
}

extension ForecastIOManager: LocationManagerDelegate {

    func locationManager(manager: LocationManager, didUpdateLocation location: (latitude: Double, longitude: Double)) {
        fetchWeather(location: location, delegate: forecastDelegate)
    }

    func locationManager(manager: LocationManager, didFailWithError error: NSError) {
        print("Forecast IO Manager failed with error: \(error)")
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

//
//  ForecastIOAPIClient.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

typealias Location = (latitude: Double, longitude: Double)

///  Handles communication with the weather API.
public class ForecastIOAPIClient {
    
    // MARK: - Properties
    
    private let forecastApiKey = "7f7075d90bf85644daa070b898a10132"

    var locationClient: LocationAPIClient?
    let forecastDelegate: ForecastIOAPIClientDelegate

    // MARK: - Methods

    init(forecastDelegate: ForecastIOAPIClientDelegate) {

        self.forecastDelegate = forecastDelegate
    }

    func updateForecast() {
        locationClient = LocationAPIClient(delegate: self)
        locationClient?.requestLocation()
    }
    
    ///  Fetches the weather data and passes it to the supplied handler.
    ///
    private func fetchWeather(location: Location) {

        let units = UserDefaults.read(key: WeatherKeys.units, defaultValue: "si")
        let session = URLSession.shared()
        let weatherURL = forecastURL(location: location, units: units)
        let loadDataTask = session.dataTask(with: weatherURL) { (data, response, error) -> Void in
            if let error = error {
                self.forecastDelegate.forecast(client: self, didFailWithError: error)
            } else if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    let statusError = NSError(
                        domain: "com.vjosullivan",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    self.forecastDelegate.forecast(client: self, didFailWithError: statusError)
                } else {
                    self.forecastDelegate.forecast(client: self, didUpdateForecast: self.buildForecast(data: data!)!)
                }
            }
        }
        loadDataTask.resume()
    }

    private func buildForecast(data: Data) -> Forecast? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? JSONDictionary
            if let forecast = try ForecastIOBuilder().parseJSONForecast(data: json) {
                return forecast
            }
            return nil
        } catch {
            print("Error: Build forecast failed with error: \(error)")
        }
        return nil
    }
    private func forecastURL(location: Location, units: String) -> URL {
        return URL(string: "https://api.forecast.io/forecast/\(forecastApiKey)/\(location.latitude),\(location.longitude)?units=\(units)")!
    }
}

extension ForecastIOAPIClient: LocationAPIClientDelegate {

    ///  Delegate method, called when the location API client is successful at establishing the location.
    ///
    ///  - parameters:
    ///    - client:  The location API client providing the update.
    ///    - location: The device's current location.
    ///
    func location(client: LocationAPIClient, didUpdateLocation location: Location) {
        fetchWeather(location: location)
    }

    ///  Delegate method, called when the location API client failed to establish the location.
    ///
    ///  - parameters:
    ///    - client:  The location API client providing the error.
    ///    - error:    The error description.
    ///
    func location(client: LocationAPIClient, didFailWithError error: NSError) {
        print("Location API client failed with error: \(error)")
    }
}

protocol ForecastIOAPIClientDelegate {

    func forecast(client: ForecastIOAPIClient, didUpdateForecast forecast: Forecast)

    func forecast(client: ForecastIOAPIClient, didFailWithError error: NSError)
}

struct WeatherKeys {
    static let units    = "weather.units"
    static let windType = "weather.windtype"
}

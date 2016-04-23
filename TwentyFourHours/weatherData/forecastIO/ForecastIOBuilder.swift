//
//  WeatherBuilder.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

typealias JSONDictionary = [String: AnyObject]

class ForecastIOBuilder {
    
    let forecastIOIcons = [
        "clear-day":    "sun",
        "clear-night":  "moon",
        "rain":         "rain",
        "snow":         "snow",
        "sleet":        "sleet",
        "wind":         "wind",
        "fog":          "fog",
        "cloudy":       "cloudy",
        "partly-cloudy-day":   "partly cloudy day",
        "partly-cloudy-night": "partly cloudy night",
        "hail":         "hail",
        "thunderstorm": "thunderstorm",
        "tornado":      "tornado"
    ]

    internal func buildForecast(data: NSData) -> Forecast? {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? JSONDictionary
            return try parseJSONForecast(json)
        } catch {
            print("Error: Build forecast failed with error: \(error)")
        }
        return nil
    }
    
    func parseJSONForecast(json: JSONDictionary?) throws -> Forecast? {
        guard let json = json else {
            print("Error: Nil dictionary.")
            return nil
        }
        guard !json.isEmpty else {
            print("Error: Empty dictionary.")
            return nil
        }
        let latitude  = json["latitude"] as? Double
        let longitude = json["longitude"] as? Double
        let currentConditions = parseCurrentConditions(currentData: json["currently"] as? JSONDictionary)
        let oneDayForecasts   = parseOneDayForecasts(dailyData: json["daily"] as? JSONDictionary)
        let oneHourForecasts  = parseOneHourForecasts(hourlyData: json["hourly"] as? JSONDictionary)
        let flags             = parseFlags(flagData: json["flags"] as? JSONDictionary)
        let weatherLines: [WeatherLine]?
        if let hourForecasts = oneHourForecasts,
            let dayForecasts = oneDayForecasts {
            weatherLines = parseForecasts(hourForecasts, oneDayForecasts: dayForecasts)
        } else {
            weatherLines = nil
        }
        //BUILD WEATHER LINES
        let forecast = Forecast(
            latitude: latitude,
            longitude: longitude,
            currentConditions: currentConditions,
            oneDayForecasts: oneDayForecasts,
            oneHourForecasts: oneHourForecasts,
            units: Units(units: flags?.units ?? "si"),
            lines: weatherLines)
        return forecast
    }
    
    private func parseCurrentConditions(currentData data: JSONDictionary?) -> CurrentConditions? {
        guard let current = data else {
            return nil
        }

        return CurrentConditions(
                time:        current["time"] as? Int,
                icon:        appIcon(forecastIOIcon: current["icon"] as? String),
                summary:     current["summary"] as? String,
                temperature: current["temperature"] as? Double)
    }

    ///  Converts a forecast IO icon name into an app icon name.
    ///
    ///  - parameter icon: A forecast IO icon name
    ///
    ///  - returns: An app icon name
    ///
    private func appIcon(forecastIOIcon icon: String?) -> String {
        guard let icon = icon else {
            return "sun"
        }
        return forecastIOIcons[icon] ?? "sun"
    }

    private func parseFlags(flagData data: JSONDictionary?) -> Flags? {
        guard let flags = data else {
            return nil
        }

        var allFlags: Flags?
        allFlags = Flags(units: flags["units"] as? String)
        return allFlags ?? nil
    }

    private func parseOneDayForecasts(dailyData data: JSONDictionary?) -> [OneDayForecast]? {
        guard let days = data?["data"] as? [JSONDictionary] else {
            return nil
        }

        var oneDayForecasts = [OneDayForecast]()
        for day in days {
            let oneDayForecast = OneDayForecast(
                time:        day["time"] as! Int,
                sunriseTime: day["sunriseTime"] as? Int,
                sunsetTime:  day["sunsetTime"]  as? Int)
            oneDayForecasts.append(oneDayForecast)
        }

        return oneDayForecasts
    }

    private func parseOneHourForecasts(hourlyData data: JSONDictionary?) -> [OneHourForecast]? {
        guard let hours = data?["data"] as? [JSONDictionary] else {
            return nil
        }

        var oneHourForecasts = [OneHourForecast]()
        for hour in hours {
            oneHourForecasts.append(OneHourForecast(
                icon:        appIcon(forecastIOIcon: hour["icon"] as? String),
                summary:     hour["summary"] as? String,
                temperature: hour["temperature"] as? Double,
                time:        hour["time"] as? Int)
            )
        }
        return oneHourForecasts.count > 0 ? oneHourForecasts : nil
    }

    private func parseForecasts(oneHourForecasts: [OneHourForecast], oneDayForecasts: [OneDayForecast]) -> [WeatherLine]? { //(dayLines: [WeatherLine], hourLines: [WeatherLine])? {
        guard oneHourForecasts.count > 0 else {
            return nil
        }
        //        let latestHourForecast = oneHourForecasts.reduce(oneHourForecasts[0], combine: { max($0, $1) })
        //        for dayForecast in oneDayForecasts {
        //            if dayForecast.time <= latestHourForecast.time {
        //
        //            }
        //        }
        return nil // lines
    }
}

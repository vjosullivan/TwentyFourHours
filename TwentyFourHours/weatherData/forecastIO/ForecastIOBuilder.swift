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

    private var units: Units = Units(units: "si")
    
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

    func parseJSONForecast(data: JSONDictionary?) throws -> Forecast? {
        guard let json = data else {
            throw ForecastParsingError.NilForecastSupplied
        }
        guard !json.isEmpty else {
            throw ForecastParsingError.EmptyForecastSupplied
        }
        let flags     = parseFlags(flagData: json["flags"] as? JSONDictionary)
        self.units = Units(units: flags?.units ?? "si")
        let latitude  = json["latitude"] as? Double
        let longitude = json["longitude"] as? Double
        let currentConditions = parseCurrentConditions(currentData: json["currently"] as? JSONDictionary)
        let oneDayForecasts   = parseOneDayForecasts(dailyData: json["daily"]?["data"] as? [AnyObject])
        print("\n\njson \(json)\n\n")
        let oneHourForecasts  = parseOneHourForecasts(hourlyData: json["hourly"]?["data"] as? [AnyObject])

        let forecast = Forecast(
            latitude: latitude,
            longitude: longitude,
            units: Units(units: flags?.units ?? "si"),
            currentConditions: currentConditions,
            oneDayForecasts: oneDayForecasts,
            oneHourForecasts: oneHourForecasts)
        return forecast
    }
    
    private func parseCurrentConditions(currentData data: JSONDictionary?) -> DataPoint? {
        guard let current = data, let timestamp = current["time"] as? Int else {
            return nil
        }

        return DataPoint(
            unixTime:    timestamp,
            icon:        appIcon(forecastIOIcon: current["icon"] as? String),
            summary:     current["summary"] as? String,
            temperature: current["temperature"] as? Double,
            precipitationIntensity: current["precipIntensity"] as? Double,
            precipitationProbability: current["precipProbability"] as? Double,
            precipitationType: current["precipType"] as? String,
            units: self.units
        )
    }

    private func parseFlags(flagData data: JSONDictionary?) -> Flags? {
        guard let flags = data else {
            return nil
        }

        return Flags(units: flags["units"] as? String)
    }

    private func parseOneDayForecasts(dailyData data: [AnyObject]?) -> [OneDayForecast]? {
        guard let days = data as? [JSONDictionary] else {
            return nil
        }

        var oneDayForecasts = [OneDayForecast]()
        for day in days {
            let sunriseTime = day["sunriseTime"] as? Int
            let sunsetTime  = day["sunsetTime"]  as? Int
            if sunriseTime != nil || sunsetTime != nil {
                oneDayForecasts.append(OneDayForecast(
                    unixTime:    day["time"] as? Int,
                    sunriseTime: sunriseTime,
                    sunsetTime:  sunsetTime))
            }
        }

        return oneDayForecasts.count > 0 ? oneDayForecasts : nil
    }

    private func parseOneHourForecasts(hourlyData data: [AnyObject]?) -> [DataPoint]? {
        guard let hours = data as? [JSONDictionary] else {
            return nil
        }
        var oneHourForecasts = [DataPoint]()
        for hour in hours {
            if let timestamp = hour["time"] as? Int {
                let forecast = DataPoint(
                    unixTime:    timestamp,
                    icon:        appIcon(forecastIOIcon: hour["icon"] as? String),
                    summary:     hour["summary"] as? String,
                    temperature: hour["temperature"] as? Double,
                    precipitationIntensity: hour["precipIntensity"] as? Double,
                    precipitationProbability: hour["precipProbability"] as? Double,
                    precipitationType: hour["precipType"] as? String,
                    units: self.units
                )
                oneHourForecasts.append(forecast)
            }
        }
        return oneHourForecasts.count > 0 ? oneHourForecasts : nil
    }

    ///  Converts a forecast IO icon name into an app icon name.
    ///
    ///  - parameter icon: A forecast IO icon name
    ///
    ///  - returns: An app icon name
    ///
    private func appIcon(forecastIOIcon icon: String?) -> String? {
        guard let icon = icon else {
            return nil
        }
        return forecastIOIcons[icon] ?? "sun"
    }
}

enum ForecastParsingError: ErrorType {
    case NilForecastSupplied
    case EmptyForecastSupplied
}

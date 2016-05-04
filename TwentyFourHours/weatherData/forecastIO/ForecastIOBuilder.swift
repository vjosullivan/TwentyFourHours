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

    func parseJSONForecast(data: JSONDictionary?) throws -> Forecast? {
        guard let json = data else {
            throw ForecastParsingError.NilForecastSupplied
        }
        guard !json.isEmpty else {
            throw ForecastParsingError.EmptyForecastSupplied
        }
        let latitude  = json["latitude"] as? Double
        let longitude = json["longitude"] as? Double
        let currentConditions = parseCurrentConditions(currentData: json["currently"] as? JSONDictionary)
        let oneDayForecasts   = parseOneDayForecasts(dailyData: json["daily"]?["data"] as? [AnyObject])
        print("\n\njson \(json)\n\n")
        let oneHourForecasts  = parseOneHourForecasts(hourlyData: json["hourly"]?["data"] as? [AnyObject])
        let flags             = parseFlags(flagData: json["flags"] as? JSONDictionary)

        let forecast = Forecast(
            latitude: latitude,
            longitude: longitude,
            units: Units(units: flags?.units ?? "si"),
            currentConditions: currentConditions,
            oneDayForecasts: oneDayForecasts,
            oneHourForecasts: oneHourForecasts)
        return forecast
    }
    
    private func parseCurrentConditions(currentData data: JSONDictionary?) -> CurrentConditions? {
        guard let current = data else {
            return nil
        }

        return CurrentConditions(
                unixTime:    current["time"] as? Int,
                icon:        appIcon(forecastIOIcon: current["icon"] as? String),
                summary:     current["summary"] as? String,
                temperature: current["temperature"] as? Double)
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
            let oneDayForecast = OneDayForecast(
                unixTime:    day["time"] as? Int,
                sunriseTime: day["sunrise"] as? Int,
                sunsetTime:  day["sunset"]  as? Int)
            if oneDayForecast.containsData {
                oneDayForecasts.append(oneDayForecast)
            }
        }

        return oneDayForecasts.count > 0 ? oneDayForecasts : nil
    }

    private func parseOneHourForecasts(hourlyData data: [AnyObject]?) -> [OneHourForecast]? {
        guard let hours = data as? [JSONDictionary] else {
            return nil
        }
        var oneHourForecasts = [OneHourForecast]()
        for hour in hours {
            let forecast = OneHourForecast(
                unixTime:    hour["time"] as? Int,
                icon:        appIcon(forecastIOIcon: hour["icon"] as? String),
                summary:     hour["summary"] as? String,
                temperature: hour["temperature"] as? Double
            )
            if forecast.containsData {
                oneHourForecasts.append(forecast)
            }
        }
        return oneHourForecasts.count > 0 ? oneHourForecasts : nil
    }

//    private func parseForecasts(oneHourForecasts: [OneHourForecast], oneDayForecasts: [OneDayForecast]) -> [WeatherLine]? { //(dayLines: [WeatherLine], hourLines: [WeatherLine])? {
//        guard oneHourForecasts.count > 0 else {
//            return nil
//        }
//        //        let latestHourForecast = oneHourForecasts.reduce(oneHourForecasts[0], combine: { max($0, $1) })
//        //        for dayForecast in oneDayForecasts {
//        //            if dayForecast.time <= latestHourForecast.time {
//        //
//        //            }
//        //        }
//        return nil // lines
//    }

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

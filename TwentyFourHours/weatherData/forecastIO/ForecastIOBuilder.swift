//
//  WeatherBuilder.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class ForecastIOBuilder {
    
    internal func buildForecast(data: NSData) -> Forecast? {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! [String: AnyObject]
            let newForecast = parseJSONForecast(json)
            return newForecast
        } catch {
            print("Build forecast failed with error: \(error)")
        }
        return nil
    }
    
    private func parseJSONForecast(json: [String: AnyObject]) -> Forecast {
        let latitude         = json["latitude"] as? Double
        let longitude        = json["longitude"] as? Double
        let currentConditions          = parseCurrentConditions(json)
        let oneDayForecasts = parseOneDayForecasts(json)
        let oneHourForecasts = parseOneHourForecasts(json)
        let flags    = parseFlags(json)
        let timezone = json["timezone"] as? String
        let offset   = json["offset"] as? Double
        let weatherLines = parseForecasts(oneHourForecasts!, oneDayForecasts: oneDayForecasts!)
        //BUILD WEATHER LINES
        let forecast = Forecast(
            latitude: latitude,
            longitude: longitude,
            currentConditions: currentConditions,
            oneDayForecasts: oneDayForecasts,
            oneHourForecasts: oneHourForecasts,
            timezone:  timezone,
            offset: offset,
            units: Units(units: flags?.units ?? "si"),
            lines: weatherLines)
        return forecast
    }
    
    private func parseCurrentConditions(json: [String: AnyObject]) -> CurrentConditions? {
        var currentConditions: CurrentConditions?
        if let current = json["currently"] as? [String: AnyObject] {
            currentConditions = CurrentConditions(
                time:        current["time"] as? Int,
                icon:        appIconName(current["icon"] as? String),
                summary:     current["summary"] as? String,
                temperature: current["temperature"] as? Double)
        }
        return currentConditions ?? nil
    }

    private func appIconName(iconName: String?) -> String {
        let result: String
        if let iconName = iconName {
            switch iconName {
            case "clear-day":
                result = "sun"
            case "clear-night":
                result = "moon"
            case "rain":
                result = "rain"
            case "snow":
                result = "snow"
            case "sleet":
                result = "sleet"
            case "wind":
                result = "wind"
            case "fog":
                result = "fog"
            case "cloudy":
                result = "cloudy"
            case "partly-cloudy-day":
                result = "partly cloudy day"
            case "partly-cloudy-night":
                result = "partly cloudy night"
            case "hail":
                result = "hail"
            case "thunderstorm":
                result = "thunderstorm"
            case "tornado":
                result = "tornado"
            default:
                result = "sun"
            }
        } else {
            result = "sun"
        }
        return result
    }


    private func parseFlags(json: [String: AnyObject]) -> Flags? {
        var allFlags: Flags?
        if let flags = json["flags"] as? [String: AnyObject] {
            allFlags = Flags(units: flags["units"] as? String)
        }
        return allFlags ?? nil
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
    
    private func parseOneDayForecasts(json: [String: AnyObject]) -> [OneDayForecast]? {
        var oneDayForecasts = [OneDayForecast]()
        if let daily = json["daily"] as? [String: AnyObject],
            let dailyData = daily["data"] as? [[String: AnyObject]] {
            for day in dailyData {
                let oneDayForecast = OneDayForecast(
                    time:        day["time"] as! Int,
                    sunriseTime: day["sunriseTime"] as? Int,
                    sunsetTime:  day["sunsetTime"]  as? Int)
                oneDayForecasts.append(oneDayForecast)
            }

        }
        return oneDayForecasts
    }

    private func parseOneHourForecasts(json: [String: AnyObject]) -> [OneHourForecast]? {
        var oneHourForecasts = [OneHourForecast]()
        if let hourly = json["hourly"] as? [String: AnyObject],
            let hourlyData = hourly["data"] as? [[String: AnyObject]] {
                for hour in hourlyData {
                    oneHourForecasts.append(OneHourForecast(
                        icon:        hour["icon"] as? String,
                        summary:     hour["summary"] as? String,
                        temperature: hour["temperature"] as? Double,
                        time:        hour["time"] as? Int)
                    )
                }
        }
        return oneHourForecasts.count > 0 ? oneHourForecasts : nil
    }
}

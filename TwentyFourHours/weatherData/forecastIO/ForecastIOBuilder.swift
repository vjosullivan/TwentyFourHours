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
        let forecast = Forecast(
            latitude: latitude,
            longitude: longitude,
            currentConditions: currentConditions,
            oneDayForecasts: oneDayForecasts,
            oneHourForecasts: oneHourForecasts,
            timezone:  timezone,
            offset: offset,
            units: Units(units: flags?.units ?? "si"))
        return forecast
    }
    
    private func parseCurrentConditions(json: [String: AnyObject]) -> CurrentConditions? {
        var currentConditions: CurrentConditions?
        if let current = json["currently"] as? [String: AnyObject] {
            currentConditions = CurrentConditions(
                time:        current["time"] as? Int,
                icon:        current["icon"] as? String,
                summary:     current["summary"] as? String,
                temperature: current["temperature"] as? Double)
        }
        return currentConditions ?? nil
    }
    
    private func parseFlags(json: [String: AnyObject]) -> Flags? {
        var allFlags: Flags?
        if let flags = json["flags"] as? [String: AnyObject] {
            allFlags = Flags(units: flags["units"] as? String)
        }
        return allFlags ?? nil
    }
    
    private func parseOneDayForecasts(data: [String: AnyObject]) -> [OneDayForecast]? {
        var oneDayForecasts = [OneDayForecast]()
        if let allDays = data["data"] as? [[String: AnyObject]] {
            for day in allDays {
                let oneDayForecast = OneDayForecast(
                    sunriseTime: NSDate(timeIntervalSince1970: day["sunriseTime"] as! Double),
                    sunsetTime:  NSDate(timeIntervalSince1970: day["sunsetTime"] as! Double),
                    time:        NSDate(timeIntervalSince1970: day["time"] as! Double))
                oneDayForecasts.append(oneDayForecast)
            }
        }
        return oneDayForecasts.count > 0 ? oneDayForecasts : nil
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

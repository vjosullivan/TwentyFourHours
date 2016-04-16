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
            print(error)
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
            flags: flags,
            timezone:  timezone,
            offset: offset,
            units: Units(units: flags?.units ?? ""))
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
            let units = flags["units"] as? String
            allFlags = Flags(units: units)
        }
        return allFlags ?? nil
    }
    
    private func parseOneDayForecasts(data: [String: AnyObject]) -> [OneDayForecast]? {
        var oneDayForecasts = [OneDayForecast]()
        if let allDays = data["data"] as? [[String: AnyObject]] {
            for day in allDays {
                let sunriseTime = NSDate(timeIntervalSince1970: day["sunriseTime"] as! Double)
                let sunsetTime = NSDate(timeIntervalSince1970: day["sunsetTime"] as! Double)
                let time = NSDate(timeIntervalSince1970: day["time"] as! Double)
                let oneDayForecast = OneDayForecast(
                    sunriseTime: sunriseTime,
                    sunsetTime: sunsetTime,
                    time: time)
                oneDayForecasts.append(oneDayForecast)
                print("ODF \(oneDayForecast)")
            }
        }
        return oneDayForecasts.count > 0 ? oneDayForecasts : nil
    }

    private func parseOneHourForecasts(json: [String: AnyObject]) -> [OneHourForecast]? {
        var oneHourForecasts = [OneHourForecast]()
        if let hourly = json["hourly"] as? [String: AnyObject],
            let hourlyData = hourly["data"] as? [[String: AnyObject]] {
                for hour in hourlyData {
                    // TODO: Absorb temporary variables.
                    let apparentTemperature = hour["apparentTemperature"] as? Double
                    let cloudCover = hour["cloudCover"] as? Double
                    let dewPoint = hour["dewPoint"] as? Double
                    let humidity = hour["humidity"] as? Double
                    let icon = hour["icon"] as? String
                    let ozone = hour["ozone"] as? Double
                    let precipIntensity = hour["precipIntensity"] as? Double
                    let precipProbability = hour["precipProbability"] as? Double
                    let precipType = hour["precipType"] as? String
                    let pressure = hour["pressure"] as? Double
                    let summary = hour["summary"] as? String
                    let temperature = hour["temperature"] as? Double
                    let time = hour["time"] as? Int
                    let visibility = hour["visibility"] as? Int
                    let windBearing = hour["windBearing"] as? Int
                    let windSpeed = hour["windSpeed"] as? Double
                    oneHourForecasts.append(OneHourForecast(
                        apparentTemperature: apparentTemperature,
                        cloudCover: cloudCover,
                        dewPoint: dewPoint,
                        humidity: humidity,
                        icon: icon,
                        ozone: ozone,
                        precipIntensity: precipIntensity,
                        precipProbability: precipProbability,
                        precipType: precipType,
                        pressure: pressure,
                        summary: summary,
                        temperature: temperature,
                        time: time,
                        visibility: visibility,
                        windBearing: windBearing,
                        windSpeed: windSpeed))
                }
        }
        return oneHourForecasts.count > 0 ? oneHourForecasts : nil
    }
}

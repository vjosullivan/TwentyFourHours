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
        let weather          = parseWeather(json)
        let sevenDayForecast = parseSevenDayForecast(json)
        var todaysForecast: OneDayForecast? = nil
        var earliestDate = NSDate.distantFuture()
        for day in (sevenDayForecast?.oneDayForecasts)! {
            if day.time! < earliestDate {
                earliestDate = day.time!
                todaysForecast = day
            }
        }
        let oneHourForecasts = parseOneHourForecasts(json)
        let flags    = parseFlags(json)
        let timezone = json["timezone"] as? String
        let offset   = json["offset"] as? Double
        let forecast = Forecast(
            latitude: latitude,
            longitude: longitude,
            weather: weather,
            oneDayForecast: todaysForecast,
            sevenDayForecast: sevenDayForecast,
            oneHourForecasts: oneHourForecasts,
            flags: flags,
            timezone:  timezone,
            offset: offset,
            units: Units(units: flags?.units ?? ""))
        return forecast
    }
    
    private func parseWeather(json: [String: AnyObject]) -> Weather? {
        var weather: Weather?
        if let currently = json["currently"] as? [String: AnyObject] {
            //print(currently)
            let time = currently["time"] as? Int
            let icon = currently["icon"] as? String
            let summary = currently["summary"] as? String

            let temperature = currently["temperature"] as? Double
            let apparentTemperature = currently["apparentTemperature"] as? Double
            let dewPoint = currently["dewPoint"] as? Double

            let precipIntensity = currently["precipIntensity"] as? Double
            let precipProbability = currently["precipProbability"] as? Double
            let windSpeed = currently["windSpeed"] as? Double
            let nearestStormBearing = currently["nearestStormBearing"] as? Double
            let nearestStormDistance = currently["nearestStormDistance"] as? Double
            let cloudCover = currently["cloudCover"] as? Double
            let humidity = currently["humidity"] as? Double
            let windBearing = currently["windBearing"] as? Double
            let visibility = currently["visibility"] as? Double
            let pressure = currently["pressure"] as? Double
            let ozone = currently["ozone"] as? Double
            weather = Weather(time: time,
                icon: icon,
                summary: summary,
                temperature: temperature,
                apparentTemperature: apparentTemperature,
                dewPoint: dewPoint,
                precipIntensity: precipIntensity,
                precipProbability: precipProbability,
                windSpeed: windSpeed,
                nearestStormBearing: nearestStormBearing,
                nearestStormDistance: nearestStormDistance,
                cloudCover: cloudCover,
                humidity: humidity,
                windBearing: windBearing,
                visibility: visibility,
                pressure: pressure,
                ozone: ozone)
        }
        return weather ?? nil
    }
    
    private func parseFlags(json: [String: AnyObject]) -> Flags? {
        var allFlags: Flags?
        if let flags = json["flags"] as? [String: AnyObject] {
            let units = flags["units"] as? String
            allFlags = Flags(units: units)
        }
        return allFlags ?? nil
    }
    
    private func parseSevenDayForecast(json: [String: AnyObject]) -> SevenDayForecast? {
        var sevenDayForecast: SevenDayForecast?
        if let dailyData = json["daily"] as? [String: AnyObject] {
            //print("Daily: \(dailyData)")
            let oneDayForecasts = parseOneDayForecasts(dailyData)
            let icon     = dailyData["icon"] as? String
            let summary  = dailyData["summary"] as? String
            sevenDayForecast = SevenDayForecast(icon: icon, summary: summary, oneDayForecasts: oneDayForecasts)
        }
        return sevenDayForecast ?? nil
    }
    
    private func parseOneDayForecasts(data: [String: AnyObject]) -> [OneDayForecast]? {
        var oneDayForecasts = [OneDayForecast]()
        if let allDays = data["data"] as? [[String: AnyObject]] {
            for day in allDays {
                //print("Day JSON: \(day)")
                let apparentTemperatureMax = day["apparentTemperatureMax"] as? Double
                let apparentTemperatureMaxTime: NSDate?
                if let time = day["apparentTemperatureMaxTime"] as? Double {
                    apparentTemperatureMaxTime = NSDate(timeIntervalSince1970: time)
                } else {
                    apparentTemperatureMaxTime = nil
                }
                let apparentTemperatureMin = day["apparentTemperatureMin"] as? Double
                let apparentTemperatureMinTime = NSDate(timeIntervalSince1970: day["apparentTemperatureMinTime"] as! Double)
                
                let cloudCover = day["cloudCover"] as? Double
                let dewPoint = day["dewPoint"] as? Double
                let humidity = day["humidity"] as? Double
                let icon = day["icon"] as? Double
                let moonPhase = day["moonPhase"] as? Double
                let ozone = day["ozone"] as? Double
                
                let precipIntensity = day["precipIntensity"] as? Double
                let precipIntensityMax = day["precipIntensityMax"] as? Double
                let precipIntensityMaxTime = NSDate(timeIntervalSince1970: day["precipIntensityMaxTime"] as? Double ?? 0.0)
                let precipProbability = day["precipProbability"] as? Double
                let precipType = day["precipType"] as? String
                
                let pressure = day["pressure"] as? Double
                print("Pressure: \(pressure) \(day["pressure"])")
                let summary = day["summary"] as? String
                let sunriseTime = NSDate(timeIntervalSince1970: day["sunriseTime"] as! Double)
                let sunsetTime = NSDate(timeIntervalSince1970: day["sunsetTime"] as! Double)
                
                let temperatureMax = day["temperatureMax"] as? Double
                let temperatureMaxTime = NSDate(timeIntervalSince1970: day["temperatureMaxTime"] as! Double)
                let temperatureMin = day["temperatureMin"] as? Double
                let temperatureMinTime = NSDate(timeIntervalSince1970: day["temperatureMinTime"] as! Double)
                
                let time = NSDate(timeIntervalSince1970: day["time"] as! Double)
                let visibility = day["visibility"] as? Double
                
                let windBearing = day["windBearing"] as? Double
                let windSpeed = day["windSpeed"] as? Double
                let oneDayForecast = OneDayForecast(apparentTemperatureMax: apparentTemperatureMax,
                    apparentTemperatureMaxTime: apparentTemperatureMaxTime,
                    apparentTemperatureMin: apparentTemperatureMin,
                    apparentTemperatureMinTime: apparentTemperatureMinTime,
                    cloudCover:  cloudCover,
                    dewPoint: dewPoint,
                    humidity: humidity,
                    icon: icon,
                    moonPhase: moonPhase,
                    ozone: ozone,
                    precipIntensity: precipIntensity,
                    precipIntensityMax: precipIntensityMax,
                    precipIntensityMaxTime: precipIntensityMaxTime,
                    precipProbability:  precipProbability,
                    precipType: precipType,
                    pressure:  pressure,
                    summary:  summary,
                    sunriseTime: sunriseTime,
                    sunsetTime: sunsetTime,
                    temperatureMax: temperatureMax,
                    temperatureMaxTime: temperatureMaxTime,
                    temperatureMin: temperatureMin,
                    temperatureMinTime:  temperatureMinTime,
                    time: time,
                    visibility: visibility,
                    windBearing:  windBearing,
                    windSpeed: windSpeed)
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

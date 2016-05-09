//
//  ForecastIODisplayBuilder.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 06/05/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

class ForecastIOHourlyDisplay {

    let forecast: Forecast
    var dailyLines: [DayLine] {
        return parseDays(days: forecast.oneDayForecasts)
    }
    var hourlyLines: [[WeatherLine]] {
        return parseHours(days: forecast.oneDayForecasts, hours: forecast.oneHourForecasts)
    }

    private let maxHour: Int

    init(forecast: Forecast) {
        self.forecast = forecast

        maxHour = forecast.oneHourForecasts?.maxElement()?.unixTime ?? 0
    }

    private func parseDays(days days: [OneDayForecast]?) -> [DayLine] {
        guard let days = days else {
            return [DayLine]()
        }
        var lines = [DayLine]()
        for day in days {
            print("\n\nDay: \(day)\n\n")
            if let time = day.unixTime {
                let line = DayLine(time: NSDate(timeIntervalSince1970: Double(time)))
                lines.append(line)
            }
        }
        return lines
    }

    private func parseHours(days days: [OneDayForecast]?, hours: [OneHourForecast]?) -> [[WeatherLine]] {
        guard let days = days, hours = hours else {
            return [[WeatherLine]]()
        }
        var lines = [[WeatherLine]]()
        var dayIndex = 0
        for day in days {
            var line = [WeatherLine]()
            print("\n\nDay: \(day)\n\n")
            if let time = day.sunriseTime {
                let lightLine = LightLine(time: NSDate(timeIntervalSince1970: Double(time)), twilightType: .Sunrise)
                line.append(lightLine)
            }
            if let time = day.sunsetTime {
                let lightLine = LightLine(time: NSDate(timeIntervalSince1970: Double(time)), twilightType: .Sunset)
                line.append(lightLine)
            }
            for hour in hours.filter({ $0.unixTime! >= day.unixTime && $0.unixTime < (day.unixTime! + 86_400) } ){
                print("\n\nDay: \(hour)\n\n")
                if let time = hour.unixTime {
                    let hourLine = HourLine(
                        time: NSDate(timeIntervalSince1970: Double(time)),
                        temperature: nil,
                        units: nil,
                        summary: nil,
                        icon: nil)
                    line.append(hourLine)
                }
            }
            lines.append(line.sort { $0.time.timeIntervalSince1970 < $1.time.timeIntervalSince1970 })
            dayIndex += 1
        }
        return lines
    }
}
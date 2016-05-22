//
//  DisplayableForecast.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 21/05/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class DisplayableForecast {

    private let forecasts: [[WeatherSnapshot]]

    /// The number of separate (local) calendar days included in the forecast.
    var dayCount: Int {
        return forecasts.count
    }

    ///  Returns the number of data rows/lines for a given day.
    ///
    ///  - parameter day: The *index* of the day for which the data is wanted.
    ///
    ///  - returns: The number of lines of data for a given day.
    ///
    func rowCount(inDay day: Int) -> Int {
        return forecasts[day].count
    }

    ///  Returns a line of (displayable) weather data.
    ///
    ///  - parameter day:  The index of the day in question.
    ///  - parameter line: The index of the line of data being sought.
    ///
    ///  - returns: A line of (displayable) weather data.
    ///
    func forecast(day day: Int, line: Int) -> WeatherSnapshot {
        return forecasts[day][line]
    }

    init(forecast: Forecast) {
        self.forecasts = DisplayableForecast.configureForecasts(forecast)
    }

    private class func configureForecasts(forecast: Forecast) -> [[WeatherSnapshot]] {
        var forecasts = [[WeatherSnapshot]]()
        var dateIndex = forecast.currentConditions?.date
        var hourlyForecasts = [WeatherSnapshot]()
        hourlyForecasts.append(forecast.currentConditions!)
        if let hours = forecast.oneHourForecasts?.sort() {
            for hour in hours {
                if !NSCalendar.currentCalendar().isDate(hour.date, inSameDayAsDate: dateIndex!) {
                    if let dailyForecasts = forecast.oneDayForecasts {
                        hourlyForecasts.appendContentsOf(almanac(dailyForecasts, date: dateIndex!))
                    }
                    forecasts.append(hourlyForecasts.sort())
                    hourlyForecasts = [WeatherSnapshot]()
                    dateIndex = hour.date
                }
                hourlyForecasts.append(hour)
            }
            if let dailyForecasts = forecast.oneDayForecasts {
                hourlyForecasts.appendContentsOf(almanac(dailyForecasts, date: dateIndex!))
            }
            forecasts.append(hourlyForecasts.sort())
        }
        return forecasts
    }

    private class func almanac(dayForecasts: [OneDayForecast], date: NSDate) -> [WeatherSnapshot] {
        var twilights = [WeatherSnapshot]()
        for day in dayForecasts {
            if let sunrise = day.sunriseTime {
                let sunriseDate = NSDate(timeIntervalSince1970: NSTimeInterval(sunrise))
                if NSCalendar.currentCalendar().isDate(sunriseDate, inSameDayAsDate: date) {
                    twilights.append(WeatherSnapshot(unixTime: sunrise, icon: "unknown", summary: "Sunrise", temperature: nil, units: nil))
                }
            }
            if let sunset = day.sunsetTime {
                let sunriseDate = NSDate(timeIntervalSince1970: NSTimeInterval(sunset))
                if NSCalendar.currentCalendar().isDate(sunriseDate, inSameDayAsDate: date) {
                    twilights.append(WeatherSnapshot(unixTime: sunset, icon: "unknown", summary: "Sunset", temperature: nil, units: nil))
                }
            }
        }
        return twilights
    }
}
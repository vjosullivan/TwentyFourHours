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

    ///  Converts a 1D array of hourly weather forecasts into a 2D array of
    ///  displayable weather snapshots (grouped by day).
    ///
    ///  - parameter forecast: The source weather forcast.
    ///
    ///  - returns: The resulting weather snapshots.  An empty array is returned
    ///             if the source data contains no data.
    ///
    private class func configureForecasts(forecast: Forecast) -> [[WeatherSnapshot]] {
        var dateIndex = NSDate() //forecast.currentConditions?.date
        var allSnapshots    = [[WeatherSnapshot]]()  // (An array of snaphot arrays.)
        var hourlySnapshots = [WeatherSnapshot]() // (a snapshot array.)
        if let current = forecast.currentConditions {
            hourlySnapshots.append(current)
        }
        if let hours = forecast.oneHourForecasts?.sort() {
            for hour in hours {
                // Start a new day, if needed.
                if !NSCalendar.currentCalendar().isDate(hour.date, inSameDayAsDate: dateIndex) {
                    if let dailyForecasts = forecast.oneDayForecasts {
                        hourlySnapshots.appendContentsOf(almanac(dailyForecasts, date: dateIndex))
                    }
                    if hourlySnapshots.count > 0 {
                        allSnapshots.append(hourlySnapshots.sort())
                    }
                    hourlySnapshots = [WeatherSnapshot]()
                    dateIndex = hour.date
                }
                hourlySnapshots.append(hour)
            }
            if let dailyForecasts = forecast.oneDayForecasts {
                hourlySnapshots.appendContentsOf(almanac(dailyForecasts, date: dateIndex))
            }
            allSnapshots.append(hourlySnapshots.sort())
        }
        illuminateForecasts(forecasts: allSnapshots)
        return allSnapshots
    }

    ///  Adds day/night background shading to the (displayable) weather forcast snapshots.
    ///
    ///  - parameter forecasts: A set of weather snapshots.
    ///
    private class func illuminateForecasts(forecasts forecasts: [[WeatherSnapshot]]) {
        var snapshots = forecasts
        for dayIndex in 0..<snapshots.count {
            let timeOf = sunTimes(forecasts: snapshots[dayIndex])
            for lineIndex in 0..<snapshots[dayIndex].count {
                if let sunrise = timeOf.sunrise {
                    if snapshots[dayIndex][lineIndex].unixTime < sunrise {
                        snapshots[dayIndex][lineIndex].brightness = LightType.night
                        continue
                    }
                }
                if let sunset = timeOf.sunset {
                    if snapshots[dayIndex][lineIndex].unixTime > sunset {
                        snapshots[dayIndex][lineIndex].brightness = LightType.night
                        continue
                    }
                }
                snapshots[dayIndex][lineIndex].brightness = LightType.day
            }
        }
    }

    private class func sunTimes(forecasts forecasts: [WeatherSnapshot]) -> (sunrise: Int?, sunset: Int?) {
        return (sunrise: 1, sunset: 1)
    }

    ///  Extracts and returns the sunrise and sunset data for a particular day,
    ///  from the given set of one day forecasts.
    ///
    ///  - parameter dayForecasts: Source data array of one day forecasts.
    ///  - parameter date:         The date for which the data is required.
    ///
    ///  - returns: Sunrise and/or sunset times for a given day.  If there is
    ///             no sunrise or sunset on that day then no entry is returned.
    ///             If neither occur then an empty array is returned.
    ///
    private class func almanac(dayForecasts: [OneDayForecast], date: NSDate) -> [WeatherSnapshot] {
        var twilights = [WeatherSnapshot]()
        for forecast in dayForecasts {
            if let sunrise = takeSnapshot(event: .sunrise, date: date, data: forecast) {
                // Ignore past sunrises.
                if sunrise.date > nowMinus1Hour {
                    twilights.append(sunrise)
                }
            }
            if let sunset = takeSnapshot(event: .sunset, date: date, data: forecast) {
                // Ignore too far distant sunrises.
                if sunset.date <= nowPlus49Hours {
                    twilights.append(sunset)
                }
            }
        }
        return twilights
    }

    ///  Looks for a event occurring on the given date in the supplied data.
    ///
    ///  - parameters:
    ///    - event: The event (sunrise, etc.) being sought
    ///    - date:  The event data.
    ///    - data:  Data for the day (that may include the event).
    ///
    ///  - returns: If found, a snapshot of the event is returned.
    ///
    private class func takeSnapshot(event event: EventType, date: NSDate, data: OneDayForecast) -> WeatherSnapshot? {
        var result: WeatherSnapshot?
        let eventTime = event == .sunrise ? data.sunriseTime : data.sunsetTime
        if let time = eventTime {
            let sunriseDate = NSDate(timeIntervalSince1970: NSTimeInterval(time))
            if NSCalendar.currentCalendar().isDate(sunriseDate, inSameDayAsDate: date) {
                let text = event == .sunrise ? "Sunrise" : "Sunset"
                result = WeatherSnapshot(unixTime: time, icon: "unknown", summary: text, temperature: nil, units: nil)
            }
        }
        return result
    }

    /// The time 1 hour ago.
    class var nowMinus1Hour: NSDate {
        let now = NSDate()
        let plus49 = NSCalendar.currentCalendar().dateByAddingUnit(
            .Hour,
            value: -1,
            toDate: now,
            options: NSCalendarOptions(rawValue: 0))
        return plus49!
    }

    /// The time 49 hours from now.
    class var nowPlus49Hours: NSDate {
        let now = NSDate()
        let plus49 = NSCalendar.currentCalendar().dateByAddingUnit(
            .Hour,
            value: 49,
            toDate: now,
            options: NSCalendarOptions(rawValue: 0))
        return plus49!
    }
}

private enum EventType {
    case sunrise
    case sunset
}
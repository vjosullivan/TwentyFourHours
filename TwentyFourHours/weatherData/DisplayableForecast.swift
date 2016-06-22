//
//  DisplayableForecast.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 21/05/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class DisplayableForecast {

    private let forecasts: [[DataPoint]]

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
    func forecast(day: Int, line: Int) -> DataPoint {
        return forecasts[day][line]
    }

    init(forecast: Forecast) {
        self.forecasts = DisplayableForecast.configureForecasts(forecast: forecast)
    }

    ///  Converts a 1D array of hourly weather forecasts into a 2D array of
    ///  displayable weather datapoints (grouped by day).
    ///
    ///  - parameter forecast: The source weather forcast.
    ///
    ///  - returns: The resulting weather datapoints.  An empty array is returned
    ///             if the source data contains no data./Applications/Audirvana Plus 2.app
    ///
    private class func configureForecasts(forecast: Forecast) -> [[DataPoint]] {
        var dateIndex = Date() //forecast.currentConditions?.date
        var allDataPoints    = [[DataPoint]]()  // (An array of DataPoint arrays.)
        var hourlyDataPoints = [DataPoint]() // (a datapoint array.)
        if let current = forecast.currentConditions {
            hourlyDataPoints.append(current)
        }
        let hourlyForecasts = (forecast.oneHourForecasts ?? [DataPoint]()).sorted(isOrderedBefore: dataPointOrder)
        for hour in hourlyForecasts {
            // Start a new day, if needed.
            if !Calendar.current().isDate(hour.date, inSameDayAs: dateIndex) {
                if let dailyForecasts = forecast.oneDayForecasts {
                    hourlyDataPoints.append(contentsOf: almanac(dayForecasts: dailyForecasts, date: dateIndex))
                }
                if hourlyDataPoints.count > 0 {
                    allDataPoints.append(hourlyDataPoints.sorted(isOrderedBefore: dataPointOrder))
                }
                hourlyDataPoints = [DataPoint]()
                dateIndex = hour.date
            }
            hourlyDataPoints.append(hour)
        }
        if let dailyForecasts = forecast.oneDayForecasts {
            hourlyDataPoints.append(contentsOf: almanac(dayForecasts: dailyForecasts, date: dateIndex))
        }
        allDataPoints.append(hourlyDataPoints.sorted(isOrderedBefore: dataPointOrder))

        return illuminateDataPoints(dataPoints: allDataPoints)
    }

    ///  Adds day/night background shading to the (displayable) weather forcast datapoints.
    ///
    ///  - parameter forecasts: A set of weather datapoints.
    ///
    private class func illuminateDataPoints(dataPoints: [[DataPoint]]) -> [[DataPoint]] {
        var newPoints = dataPoints
        for dayIndex in 0..<newPoints.count {
            let timeOf = sunTimes(forecasts: newPoints[dayIndex])
            for lineIndex in 0..<newPoints[dayIndex].count {
                if let sunrise = timeOf.sunrise {
                    if newPoints[dayIndex][lineIndex].unixTime < sunrise {
                        newPoints[dayIndex][lineIndex].brightness = LightType.night
                        continue
                    }
                }
                if let sunset = timeOf.sunset {
                    if newPoints[dayIndex][lineIndex].unixTime > sunset {
                        newPoints[dayIndex][lineIndex].brightness = LightType.night
                        continue
                    }
                }
                newPoints[dayIndex][lineIndex].brightness = LightType.day
            }
        }
        return newPoints
    }

    private class func sunTimes(forecasts: [DataPoint]) -> (sunrise: Int?, sunset: Int?) {
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
    private class func almanac(dayForecasts: [OneDayForecast], date: Date) -> [DataPoint] {
        var twilightTimes = [DataPoint]()
        for forecast in dayForecasts {
            if let sunrise = createDataPoint(event: .sunrise, date: date, data: forecast) {
                // Ignore past sunrises.
                if sunrise.date > nowMinus1Hour {
                    twilightTimes.append(sunrise)
                }
            }
            if let sunset = createDataPoint(event: .sunset, date: date, data: forecast) {
                // Ignore too far distant sunrises.
                if sunset.date <= nowPlus49Hours {
                    twilightTimes.append(sunset)
                }
            }
        }
        return twilightTimes
    }

    ///  Looks for a event occurring on the given date in the supplied data
    ///  and return a `DataPoint` for that event.
    ///
    ///  - parameters:
    ///    - event: The event (sunrise, etc.) being sought
    ///    - date:  The event data.
    ///    - data:  Data for the day (that may include the event).
    ///
    ///  - returns: If found, a datapoint of the event is returned.
    ///
    private class func createDataPoint(event: EventType, date: Date, data: OneDayForecast) -> DataPoint? {
        var result: DataPoint?
        let eventTime = event == .sunrise ? data.sunriseTime : data.sunsetTime
        if let time = eventTime {
            let sunriseDate = Date(timeIntervalSince1970: TimeInterval(time))
            if Calendar.current().isDate(sunriseDate, inSameDayAs: date) {
                let text = event == .sunrise ? "Sunrise" : "Sunset"
                result = HourlyDataPoint(unixTime: time, icon: "sunrise", summary: text, temperature: nil, precipitationIntensity: nil, precipitationProbability: nil, precipitationType: nil, units: nil)
            }
        }
        return result
    }

    /// The time 1 hour ago.
    class var nowMinus1Hour: Date {
        let oneHourAgo = Calendar.current().date(byAdding: .hour, value: -1, to: Date(), options: Calendar.Options(rawValue: 0))
        return oneHourAgo!
    }

    /// The time 49 hours from now.
    class var nowPlus49Hours: Date {
        let result = Calendar.current().date(byAdding: .hour, value: -1, to: Date(), options: Calendar.Options(rawValue: 0))
        return result!
    }
}

private enum EventType {
    case sunrise
    case sunset
}

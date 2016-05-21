//
//  DisplayableForecast.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 21/05/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

class DisplayableForecast {

    private let forecasts: [[OneHourForecast]]

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
    func forecast(day day: Int, line: Int) -> OneHourForecast {
        return forecasts[day][line]
    }

    init(forecast: Forecast) {
        var forecasts = [[OneHourForecast]]()
        var dateIndex = forecast.currentConditions?.date
        var hourlyForecasts = [OneHourForecast]()
        // TODO: hoursData.append(forecast.currentConditions)
        if let hours = forecast.oneHourForecasts?.sort() {
            for hour in hours {
                if !NSCalendar.currentCalendar().isDate(hour.date, inSameDayAsDate: dateIndex!) {
                    if hourlyForecasts.count > 0 {
                        forecasts.append(hourlyForecasts)
                        hourlyForecasts = [OneHourForecast]()
                    }
                    dateIndex = hour.date
                }
                hourlyForecasts.append(hour)
            }
            if hourlyForecasts.count > 0 {
                forecasts.append(hourlyForecasts)
                hourlyForecasts = [OneHourForecast]()
            }
        }
        self.forecasts = forecasts
    }
}
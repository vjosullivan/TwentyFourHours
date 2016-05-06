//
//  ForecastIODisplayBuilder.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 06/05/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

class ForecastIODisplayBuilder {

    let forecast: Forecast
    var dailyLines: [DayLine] {
        return parseDays(days: forecast.oneDayForecasts)
    }
    var hourlyLines: [WeatherLine] {
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
        for day in days {
            print(day)
        }
        return [DayLine]()
    }

    private func parseHours(days days: [OneDayForecast]?, hours: [OneHourForecast]?) -> [WeatherLine] {
        guard let days = days, hours = hours else {
            return [WeatherLine]()
        }
        for day in days {
            print(day)
        }
        for hour in hours {
            print(hour)
        }
        return [WeatherLine]()
    }
}
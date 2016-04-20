//
//  Forecast.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

struct Forecast {

    /// The reqested latitude for the forecast.
    let latitude: Double?
    /// The requested longitude for the forecast.
    let longitude: Double?

    ///  The current weather conditions.
    let weather: Weather?
    /// The weather forecast summary for the next 24 hours
    let oneDayForecast: OneDayForecast?
    ///  The weather forecast summary for the next week.
    let sevenDayForecast: SevenDayForecast?
    /// A collection of one-hour forecasts covering the next 48 hours.
    let oneHourForecasts: [OneHourForecast]?
    /// A container holding 60 one-minute forecasts, covering the next hour.
    let sixtyMinuteForecast: SixtyMinuteForecast?

    /// Meta-data relating to the weather data.
    let flags: Flags?
    /// The IANA timezone name for the requested location (e.g. America/New_York).
    let timezone: String?
    /// (Depricated.)  The current timezone offset in hours from GMT.
    let offset: Double?

    let units: Units
}

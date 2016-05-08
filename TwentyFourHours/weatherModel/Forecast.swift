//
//  Forecast.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

struct Forecast {

    let latitude: Double?
    let longitude: Double?
    let units: Units?

    let currentConditions: CurrentConditions?
    let oneDayForecasts: [OneDayForecast]?
    let oneHourForecasts: [OneHourForecast]?

    /// Returns a forecast that contains nothing.
    internal static var emptyForecast: Forecast {
        return Forecast(latitude: nil,
                           longitude: nil,
                           units: nil,
                           currentConditions: nil,
                           oneDayForecasts: nil,
                           oneHourForecasts: nil)
    }
}
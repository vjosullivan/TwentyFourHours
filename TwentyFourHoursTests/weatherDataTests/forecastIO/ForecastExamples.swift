//
//  ForecastExamples.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 08/05/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//
@testable import TwentyFourHours

struct ForecastExamples {

    let nilForecast = Forecast(latitude: nil,
                               longitude: nil,
                               units: nil,
                               currentConditions: nil,
                               oneDayForecasts: nil,
                               oneHourForecasts: nil)
}

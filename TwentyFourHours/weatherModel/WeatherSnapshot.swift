//
//  OneHourForecast.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

struct WeatherSnapshot {
    
    let unixTime: Int?
    let icon: String?
    let summary: String?
    let temperature: Double?
    let units: Units?

    var containsData: Bool {
        return unixTime != nil && icon != nil && summary != nil && temperature != nil
    }

    var date: NSDate {
        return NSDate(timeIntervalSince1970: NSTimeInterval(unixTime!))
    }
}

extension WeatherSnapshot: Comparable {}

func == (x: WeatherSnapshot, y: WeatherSnapshot) -> Bool { return x.unixTime == y.unixTime }
func <  (x: WeatherSnapshot, y: WeatherSnapshot) -> Bool { return x.unixTime <  y.unixTime }

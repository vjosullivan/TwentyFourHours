//
//  Weather.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 01/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

///  Represents (properties of) the current weather.
///

import Foundation

struct Weather {

    let time: Int?
    let icon: String?
    let summary: String?

    let temperature: Double?
    let apparentTemperature: Double?
    let dewPoint: Double?

    /// **Precipitation intensity**:  A numerical value representing the average expected intensity (in inches of liquid water per hour) of precipitation occurring at the given time conditional on probability (that is, assuming any precipitation occurs at all).<br/><br/>A very rough guide is that a value of 0 in./hr. corresponds to no precipitation, 0.002 in./hr. corresponds to very light precipitation, 0.017 in./hr. corresponds to light precipitation, 0.1 in./hr. corresponds to moderate precipitation, and 0.4 in./hr. corresponds to heavy precipitation.
    let precipIntensity: Double?
    let precipProbability: Double?
    let windSpeed: Double?
    let nearestStormBearing: Double?
    let nearestStormDistance: Double?
    let cloudCover: Double?
    let humidity: Double?
    let windBearing: Double?
    let visibility: Double?
    let pressure: Double?
    let ozone: Double?

    var date: NSDate {
        let d = NSDate(timeIntervalSince1970: NSTimeInterval(time!))
        return d
    }
}

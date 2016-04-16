//
//  DailyData.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 01/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//
import Foundation

struct OneDayForecast {

    let sunriseTime: NSDate?
    let sunsetTime: NSDate?
    let time: NSDate?
}

extension OneDayForecast: CustomStringConvertible {

    var description: String {
        let sun  = "Date=\(time?.asYYYYMMDD() ?? "?"), time=\(time?.asHHMM() ?? "?"), rise=\(sunriseTime?.asHHMM() ?? "?"), set=\(sunsetTime?.asHHMM() ?? "?")"
        return "OneDay: \(sun)\n"
    }
}

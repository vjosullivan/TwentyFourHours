//
//  HourLine.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 20/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

struct HourLine {

    let type = WeatherLineType.HourLine
    let time: NSDate
    let temperature: Double
    let units: String
    let summary: String
    let icon: String

    init(time: NSDate, temperature: Double, units: String, summary: String, icon: String) {
        self.time        = time
        self.temperature = temperature
        self.units       = units
        self.summary     = summary
        self.icon        = icon
    }

    func text() -> String {
        return summary
    }
}
//
//  HourLine.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 20/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

struct HourLine: WeatherLine {

    let type = WeatherLineType.HourLine

    let time: NSDate
    let temperature: Double?
    let units: String?
    let summary: String?
    let icon: String?

    var text: String {
        return summary ?? ""
    }
}
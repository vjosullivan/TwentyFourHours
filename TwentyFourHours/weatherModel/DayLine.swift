//
//  File.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 20/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

struct DayLine: WeatherLine {

    let type = WeatherLineType.DayLine
    let time: NSDate

    init(time: NSDate) {
        self.time         = time
    }

    func text() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"

        return formatter.stringFromDate(time)
    }
}
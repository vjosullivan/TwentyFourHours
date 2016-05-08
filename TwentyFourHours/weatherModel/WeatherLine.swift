//
//  WeatherLine.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 20/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

protocol WeatherLine {

    var type: WeatherLineType { get }
    var time: NSDate { get }
    var text: String { get }
}

enum WeatherLineType {
    case DayLine
    case LightLine
    case HourLine
}

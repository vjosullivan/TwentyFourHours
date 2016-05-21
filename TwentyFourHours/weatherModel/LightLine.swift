//
//  LightLine.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 20/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

struct LightLine: WeatherLineX {

    let time: NSDate
    let twilightType: TwilightType
    let type = WeatherLineType.LightLine

    func text() -> String {
        return twilightType.rawValue
    }
}

enum TwilightType: String {
    case AstronomicalTwilightDawn = "Astronomical twilight begins"
    case NavalTwilightDawn        = "Naval twilight begins"
    case CivilTwilightDawn        = "Civil twilight begins"
    case Sunrise                  = "Sunrise"
    case GoldenHourEnds           = "Golden hour ends"
    case GoldenHourBegins         = "Golden hour begins"
    case Sunset                   = "Sunset"
    case CivilTwilightDusk        = "Civil twilight ends"
    case NavalTwilightDusk        = "Naval twilight ends"
    case AstronomicalTwilightDusk = "Astronomical twilight ends"
}
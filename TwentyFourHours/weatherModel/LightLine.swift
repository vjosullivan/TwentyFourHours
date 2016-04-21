//
//  LightLine.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 20/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

struct LightLine: WeatherLine {

    let time: NSDate
    let twilightType: TwilightType
    let type = WeatherLineType.LightLine

    func text() -> String {
        return "Sunrise"
    }
}

enum TwilightType {
    case AstronomicalTwilightDawn
    case NavalTwilightDawn
    case CivilTwilightDawn
    case Dawn
    case GoldenHourEnds
    case GoldenHourBegins
    case Dusk
    case CivilTwilightDusk
    case NavalTwilightDusk
    case AstronomicalTwilightDusk
}
//
//  OneHourForecast.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

struct DataPoint {

    let unixTime: Int

    let icon: String?
    let summary: String?
    let precipitationIntensity: Double?
    let precipitationProbability: Double?
    let precipitationType: String?
    let temperature: Double?
    let units: Units?

    var brightness: LightType? = nil

    init(unixTime: Int,
         icon: String?,
         summary: String?,
         temperature: Double?,
         precipitationIntensity: Double?,
         precipitationProbability: Double?,
         precipitationType: String?,
         units: Units?) {
        self.unixTime    = unixTime
        self.icon        = icon
        self.summary     = summary
        self.temperature = temperature

        self.precipitationIntensity = precipitationIntensity
        self.precipitationProbability = precipitationProbability
        self.precipitationType = precipitationType

        self.units       = units
    }

    var date: NSDate {
        return NSDate(timeIntervalSince1970: NSTimeInterval(unixTime))
    }
}

extension DataPoint: Comparable {}

func == (x: DataPoint, y: DataPoint) -> Bool { return x.unixTime == y.unixTime }
func <  (x: DataPoint, y: DataPoint) -> Bool { return x.unixTime <  y.unixTime }

enum LightType {
    case day
    case night
}
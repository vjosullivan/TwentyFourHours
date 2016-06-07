//
//  HourlyDataPoint.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 05/06/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

typealias CurrentDataPoint = HourlyDataPoint

struct HourlyDataPoint: DataPoint {

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
}

extension HourlyDataPoint: Comparable {}

func == (x: HourlyDataPoint, y: HourlyDataPoint) -> Bool { return x.unixTime == y.unixTime }
func <  (x: HourlyDataPoint, y: HourlyDataPoint) -> Bool { return x.unixTime <  y.unixTime }

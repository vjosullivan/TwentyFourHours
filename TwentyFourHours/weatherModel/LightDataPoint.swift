//
//  LightDataPoint.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 05/06/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

struct LightDataPoint: DataPoint {

    let unixTime: Int

    let icon: String?
    let summary: String?
    let temperature: Double?
    let units: Units?

    var brightness: LightType? = nil

    init(unixTime: Int, icon: String, summary: String) {
        self.unixTime    = unixTime
        self.icon        = icon
        self.summary     = summary

        self.temperature = nil
        self.units       = nil
    }
}

enum LightType {
    case day
    case night
}
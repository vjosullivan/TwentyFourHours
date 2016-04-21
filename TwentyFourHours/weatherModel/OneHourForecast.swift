//
//  OneHourForecast.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

struct OneHourForecast {
    
    let icon: String?
    let summary: String?
    let temperature: Double?
    let time: Int?
}

extension OneHourForecast: Comparable {}

func == (x: OneHourForecast, y: OneHourForecast) -> Bool { return x.time == y.time }
func <  (x: OneHourForecast, y: OneHourForecast) -> Bool { return x.time <  y.time }


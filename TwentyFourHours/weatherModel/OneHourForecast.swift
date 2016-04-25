//
//  OneHourForecast.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

struct OneHourForecast {
    
    let unixTime: Int?
    let icon: String?
    let summary: String?
    let temperature: Double?

    var containsData: Bool {
        return unixTime != nil && icon != nil && summary != nil && temperature != nil
    }
}

extension OneHourForecast: Comparable {}

func == (x: OneHourForecast, y: OneHourForecast) -> Bool { return x.unixTime == y.unixTime }
func <  (x: OneHourForecast, y: OneHourForecast) -> Bool { return x.unixTime <  y.unixTime }


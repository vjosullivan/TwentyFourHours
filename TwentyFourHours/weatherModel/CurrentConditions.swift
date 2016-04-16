//
//  CurrentConditions.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 01/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

///  Represents (properties of) the current weather.
///

import Foundation

struct CurrentConditions {

    let time: Int?
    let icon: String?
    let summary: String?

    let temperature: Double?

    var date: NSDate {
        let d = NSDate(timeIntervalSince1970: NSTimeInterval(time!))
        return d
    }
}

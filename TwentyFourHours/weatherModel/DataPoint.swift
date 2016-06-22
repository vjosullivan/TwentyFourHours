//
//  DataPoint.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/02/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import Foundation

protocol DataPoint {

    var unixTime: Int { get }

    var temperature: Double? { get }
    var units: Units? { get }
    var summary: String? { get }
    var icon: String? { get }

    var brightness: LightType? { get set }
}

extension DataPoint {

    var date: Date {
        return Date(timeIntervalSince1970:
            TimeInterval(unixTime))
    }
}

///  For use in sorting.
///
///  - returns: `true` if `dataPoint1` is before `dataPoint2`, otherwise `false`.
///
func dataPointOrder(point1: DataPoint, point2: DataPoint) -> Bool {
    return point1.unixTime < point2.unixTime
}


//
//  mockWeatherTableViewCell.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 20/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit
@testable import TwentyFourHours

class mockWeatherTableViewCell: WeatherTableViewCell {

    var localTempLabel = UILabel()

    override var tempLabel: UILabel! {
        get {
            return localTempLabel
        }
        set {
            localTempLabel = newValue
        }
    }
    override var CFLabel: UILabel! {
        get { return UILabel() }
        set { }
    }
    override var dayLabel: UILabel! {
        get { return UILabel() }
        set { }
    }
    override var timeLabel: UILabel! {
        get { return UILabel() }
        set { }
    }
    override var rainLabel: UILabel! {
        get { return UILabel() }
        set { }
    }
    override var minsLabel: UILabel! {
        get { return UILabel() }
        set { }
    }
    override weak var weatherIcon: UIImageView! {
        get { return UIImageView() }
        set { }
    }
}

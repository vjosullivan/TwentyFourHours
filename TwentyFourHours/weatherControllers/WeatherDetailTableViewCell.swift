//
//  WeatherDetailTableViewCell.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 28/05/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class WeatherDetailTableViewCell: UITableViewCell {

    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var minsLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var CFLabel: UILabel!
    @IBOutlet var rainLabel: UILabel!
    @IBOutlet var weatherIcon: UIImageView!

    func configure(datapoint: DataPoint) {
        tempLabel!.text = datapoint.temperature != nil ? "\(Int(round(datapoint.temperature!)))" : ""

        CFLabel.text = datapoint.units?.temperature ?? ""

        timeLabel!.text = hour(Double(datapoint.unixTime))
        minsLabel!.text = minute(Double(datapoint.unixTime))

        rainLabel!.text = datapoint.summary ?? ""
        // Unit test work around (because UIImageView is always nil in my unit tests).
        if let weatherIcon = self.weatherIcon,
            let iconName = datapoint.icon {
            weatherIcon.image = weatherImage(iconName)
        }
        cellColours()

        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsetsZero
        layoutMargins  = UIEdgeInsetsZero
    }

    func cellColours() {
        let cellBackgroundColor = UIColor.blackColor()
        let cellForegroundColor = minsLabel.text == ":00" ? UIColor.whiteColor() : UIColor.greenColor()

        backgroundColor     = cellBackgroundColor

        minsLabel.textColor = cellForegroundColor
        timeLabel.textColor = cellForegroundColor
        tempLabel.textColor = cellForegroundColor
        CFLabel.textColor   = cellForegroundColor
        rainLabel.textColor = cellForegroundColor
    }

    func weatherImage(iconName: String?) -> UIImage {
        guard let foundImage = UIImage(named: iconName!) else {
            return UIImage(named: "unknown")!
        }
        return foundImage
    }
}

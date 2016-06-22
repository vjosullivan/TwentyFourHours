//
//  WeatherTableViewCell.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 14/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var minsLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var CFLabel: UILabel!
    @IBOutlet var rainLabel: UILabel!
    @IBOutlet var weatherIcon: UIImageView!

    func configure(datapoint: DataPoint) {
        tempLabel!.text = datapoint.temperature != nil ? "\(Int(round(datapoint.temperature!)))" : ""

        CFLabel.text = datapoint.units?.temperature ?? ""

        timeLabel!.text = hour(unixTime: Double(datapoint.unixTime))
        minsLabel!.text = minute(unixTime: Double(datapoint.unixTime))

        rainLabel!.text = datapoint.summary ?? ""
        // Unit test work around (because UIImageView is always nil in my unit tests).
        if let weatherIcon = self.weatherIcon,
            let iconName = datapoint.icon {
            weatherIcon.image = weatherImage(iconName: iconName)
        }
        cellColours()

        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsetsZero
        layoutMargins  = UIEdgeInsetsZero
    }

    func cellColours() {
        let cellBackgroundColor = UIColor.black()
        let cellForegroundColor = minsLabel.text == ":00" ? UIColor.white() : UIColor.green()

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

extension UITableViewCell {

    func dayStringFromUnixTime(unixTime: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTime)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEEEE"  // 2 letter day.
        return dateFormatter.string(from: date)
    }

    ///  Returns the hour value in the current calendar.
    ///
    ///  - parameter unixTime: The time stamp to be decoded.
    ///
    ///  - returns: A hour value in the range 0 to 23.
    ///
    func hour(unixTime: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTime)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H"
        return dateFormatter.string(from: date)
    }

    ///  Returns the minute value in the current calendar.
    ///
    ///  - parameter unixTime: The time stamp to be decoded.
    ///
    ///  - returns: A minute value in the range 0 to 59.
    ///
    func minute(unixTime: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTime)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ":mm"
        return dateFormatter.string(from: date)
    }
}

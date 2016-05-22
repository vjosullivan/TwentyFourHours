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

    func configure(rowIndex rowIndex: Int, forecast: Forecast?) {
        if let forecast = forecast,
            let hourly = forecast.oneHourForecasts?[rowIndex] {

            tempLabel!.text = hourly.temperature != nil ? "\(Int(round(hourly.temperature!)))" : "?"

            CFLabel.text = forecast.units.temperature

            if let dateTime = hourly.unixTime {
                timeLabel!.text = hour(Double(dateTime))
                minsLabel!.text = minute(Double(dateTime))
            } else {
                timeLabel!.text = "??"
                minsLabel!.text = "??"
            }
            rainLabel!.text = hourly.summary ?? ""
            // Unit test work around (because UIImageView is always nil in my unit tests).
            if weatherIcon != nil {
                weatherIcon.image = weatherImage(hourly.icon)
            }
            cellColours()
        }
    }

    func configure(forecast: WeatherSnapShot) {
            tempLabel!.text = forecast.temperature != nil ? "\(Int(round(forecast.temperature!)))" : "?"

            CFLabel.text = forecast.units?.temperature ?? "X"

            if let dateTime = forecast.unixTime {
                timeLabel!.text = hour(Double(dateTime))
                minsLabel!.text = minute(Double(dateTime))
            } else {
                timeLabel!.text = "??"
                minsLabel!.text = "??"
            }
            rainLabel!.text = forecast.summary ?? ""
            // Unit test work around (because UIImageView is always nil in my unit tests).
            if weatherIcon != nil {
                weatherIcon.image = weatherImage(forecast.icon)
            }
            cellColours()
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
            return UIImage(named: "sun")!
        }
        return foundImage
    }
}

extension WeatherTableViewCell {

    func dayStringFromUnixTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEEEE"  // 2 letter day.
        return dateFormatter.stringFromDate(date)
    }

    ///  Returns the hour value in the current calendar.
    ///
    ///  - parameter unixTime: The time stamp to be decoded.
    ///
    ///  - returns: A hour value in the range 0 to 23.
    ///
    func hour(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH"
        return dateFormatter.stringFromDate(date)
    }

    ///  Returns the minute value in the current calendar.
    ///
    ///  - parameter unixTime: The time stamp to be decoded.
    ///
    ///  - returns: A minute value in the range 0 to 59.
    ///
    func minute(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = ":mm"
        return dateFormatter.stringFromDate(date)
    }
}

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
                timeLabel!.text = timeStringFromUnixTime(Double(dateTime))
            } else {
                timeLabel!.text = "??"
            }
            rainLabel!.text = hourly.summary ?? ""
            // Unit test work around (because UIImageView is always nil in my unit tests).
            if weatherIcon != nil {
                weatherIcon.image = weatherImage(hourly.icon)
            }
            cellColours()
        }
    }

    func configure(forecast: OneHourForecast) {
            tempLabel!.text = forecast.temperature != nil ? "\(Int(round(forecast.temperature!)))" : "?"

            CFLabel.text = forecast.units?.temperature ?? "X"

            if let dateTime = forecast.unixTime {
                timeLabel!.text = timeStringFromUnixTime(Double(dateTime))
            } else {
                timeLabel!.text = "??"
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
        let cellForegroundColor = UIColor.whiteColor()

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

    func timeStringFromUnixTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH"
        return dateFormatter.stringFromDate(date)
    }
}

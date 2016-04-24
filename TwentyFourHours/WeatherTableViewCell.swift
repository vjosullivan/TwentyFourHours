//
//  WeatherTableViewCell.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 14/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var minsLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var CFLabel: UILabel!
    @IBOutlet var rainLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!

    func configure(rowIndex rowIndex: Int, forecast: Forecast?) {
        if let forecast = forecast,
            let hourly = forecast.oneHourForecasts?[rowIndex] {

            tempLabel!.text = hourly.temperature != nil ? "\(Int(round(hourly.temperature!)))" : "?"

            CFLabel.text = forecast.units.temperature

            if let dateTime = hourly.unixTime {
                dayLabel!.text  =  dayStringFromUnixTime(Double(dateTime))
                timeLabel!.text = timeStringFromUnixTime(Double(dateTime))
            } else {
                dayLabel!.text  = "??"
                timeLabel!.text = "??"
            }
            rainLabel!.text = hourly.summary ?? ""
            // Unit test work around (because UIImageView is always nil in my unit tests).
            if weatherIcon != nil {
                weatherIcon.image = weatherImage(hourly.icon)
            }
            let style = rowIndex < 11
                ? CellStyle.Day
                : rowIndex < 12
                ? CellStyle.Evening
                : rowIndex < 13
                ? CellStyle.Dusk
                : CellStyle.Night
            cellColours(style: style)
        }
    }

    func cellColours(style style: CellStyle) {
        let cellBackgroundColor: UIColor
        let cellForegroundColor: UIColor
        switch style {
        case .Day:
            cellBackgroundColor = UIColor.whiteColor()
            cellForegroundColor = UIColor.blackColor()
        case .Evening:
            cellBackgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.6, alpha: 1.0)
            cellForegroundColor = UIColor.blackColor()
        case .Dusk:
            cellBackgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 1.0)
            cellForegroundColor = UIColor.whiteColor()
        case .Night:
            cellBackgroundColor = UIColor.blackColor()
            cellForegroundColor = UIColor.whiteColor()
        }
        backgroundColor     = cellBackgroundColor

        dayLabel.textColor  = cellForegroundColor
        minsLabel.textColor = cellForegroundColor
        timeLabel.textColor = cellForegroundColor
        tempLabel.textColor = cellForegroundColor
        CFLabel.textColor   = cellForegroundColor
        rainLabel.textColor = cellForegroundColor
    }

    private func weatherImage(iconName: String?) -> UIImage {
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

enum CellStyle {
    case Day
    case Night
    case Evening
    case Dusk
}


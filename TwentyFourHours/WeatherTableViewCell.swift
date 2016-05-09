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
    @IBOutlet var weatherIcon: UIImageView!

    ///  Customises the appearance of the cell in accordance with the supplied data.
    ///
    ///  - parameters:
    ///    - rowIndex: The index of the cell to be updated
    ///    - forecast: The data source.
    ///
    func configure(rowIndex rowIndex: Int, forecast: Forecast?) {
        if let forecast = forecast,
            let hourly = forecast.oneHourForecasts?[rowIndex] {

            tempLabel!.text = hourly.temperature != nil ? "\(Int(round(hourly.temperature!)))" : "?"

            CFLabel.text = forecast.units?.temperature ?? ""

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
            cellColours()
        }
    }

    ///  Customises the appearance of the cell in accordance with the supplied data.
    ///
    ///  - parameters:
    ///    - rowIndex: The index of the cell to be updated
    ///    - forecast: The data source.
    ///
    func configure(rowIndex rowIndex: Int, displayLine: WeatherLine?) {
        if let line = displayLine {

            switch line.type {
            case WeatherLineType.HourLine:
                if let hourLine = line as? HourLine {
                    tempLabel!.text = hourLine.temperature != nil ? "\(Int(round(hourLine.temperature!)))" : "?"

                    CFLabel.text = hourLine.units ?? "X"

                    timeLabel!.text = hourLine.time.asHpm()

                    rainLabel!.text = hourLine.summary ?? ""
                    // Unit test work around (because UIImageView is always nil in my unit tests).
                    if weatherIcon != nil {
                        weatherIcon.image = weatherImage(hourLine.icon)
                    }
                }
            case WeatherLineType.LightLine:
                break
            case WeatherLineType.DayLine:
                break
            }
            
            cellColours()
        }
    }
    
    func cellColours() {
        let cellBackgroundColor = UIColor.blackColor()
        let cellForegroundColor = UIColor.whiteColor()

        backgroundColor     = cellBackgroundColor
        
        dayLabel.textColor  = cellForegroundColor
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

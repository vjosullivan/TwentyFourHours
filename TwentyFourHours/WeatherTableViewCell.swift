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

            tempLabel!.text = "\(Int(round(hourly.temperature ?? 0.0)))"
            CFLabel.text = forecast.units.temperature

            dayLabel!.text  =  dayStringFromUnixTime(Double(hourly.time ?? 0.0))
            timeLabel!.text = timeStringFromUnixTime(Double(hourly.time ?? 0.0))

            rainLabel!.text = hourly.summary ?? ""
            weatherIcon.image = weatherImage(hourly.icon)

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
        let image: UIImage
        if let iconName = iconName {
            switch iconName {
            case "clear-day":
                image = UIImage(named: "sun")!
            case "clear-night":
                image = UIImage(named: "moon")!
            case "rain":
                image = UIImage(named: "rain")!
            case "snow":
                image = UIImage(named: "snow")!
            case "sleet":
                image = UIImage(named: "sleet")!
            case "wind":
                image = UIImage(named: "wind")!
            case "fog":
                image = UIImage(named: "fog")!
            case "cloudy":
                image = UIImage(named: "cloudy")!
            case "partly-cloudy-day":
                image = UIImage(named: "partly cloudy day")!
            case "partly-cloudy-night":
                image = UIImage(named: "partly cloudy night")!
            case "hail":
                image = UIImage(named: "hail")!
            case "thunderstorm":
                image = UIImage(named: "thunderstorm")!
            case "tornado":
                image = UIImage(named: "tornado")!
            default:
                image = UIImage(named: "sun.png")!
            }
        } else {
            image = UIImage(named: "sun.png")!
        }
        return image
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

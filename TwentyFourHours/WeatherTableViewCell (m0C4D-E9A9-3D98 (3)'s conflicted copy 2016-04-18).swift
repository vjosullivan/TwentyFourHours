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

    func configure(cellIndex: Int, forecast: Forecast) {
        let temp = forecast.oneHourForecasts?[cellIndex].temperature ?? 0.0
        tempLabel!.text = "\(Int(round(temp)))"

        dayLabel!.text  =  dayStringFromUnixTime(Double(forecast.oneHourForecasts?[cellIndex].time ?? 0.0))
        timeLabel!.text = timeStringFromUnixTime(Double(forecast.oneHourForecasts?[cellIndex].time ?? 0.0))

        let precip    = Int(round((forecast.oneHourForecasts?[cellIndex].precipProbability ?? 0.0) * 100))
        let intensity = round((forecast.oneHourForecasts?[cellIndex].precipIntensity ?? 0.0))
        let rainType  = forecast.oneHourForecasts?[cellIndex].precipType ?? ""
        let summary  = forecast.oneHourForecasts?[cellIndex].summary ?? ""
        let icon  = forecast.oneHourForecasts?[cellIndex].icon ?? ""
        print("Timezone: \(forecast.timezone)")
        //cell.rainLabel!.text = "\(precip)% \(intensity) \(rainType) (\(icon)) \(summary)"
        rainLabel!.text = "\(summary)"
        weatherIcon.image = weatherImage(icon)

        let style = cellIndex < 11
            ? CellStyle.Day
            : cellIndex < 12
            ? CellStyle.Evening
            : cellIndex < 13
            ? CellStyle.Dusk
            : CellStyle.Night
        setCellColours(style)
    }

    private func setCellColours(style: CellStyle) {
        switch style {
        case .Day:
            backgroundColor = UIColor.whiteColor()
            dayLabel.textColor = UIColor.blackColor()
            timeLabel.textColor = UIColor.blackColor()
            minsLabel.textColor = UIColor.blackColor()
            tempLabel.textColor = UIColor.blackColor()
            CFLabel.textColor = UIColor.blackColor()
            rainLabel.textColor = UIColor.blackColor()
        case .Evening:
            backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.6, alpha: 1.0)
            dayLabel.textColor = UIColor.blackColor()
            timeLabel.textColor = UIColor.blackColor()
            minsLabel.textColor = UIColor.blackColor()
            tempLabel.textColor = UIColor.blackColor()
            CFLabel.textColor = UIColor.blackColor()
            rainLabel.textColor = UIColor.blackColor()
        case .Dusk:
            backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 1.0)
            dayLabel.textColor = UIColor.whiteColor()
            timeLabel.textColor = UIColor.whiteColor()
            minsLabel.textColor = UIColor.whiteColor()
            tempLabel.textColor = UIColor.whiteColor()
            CFLabel.textColor = UIColor.whiteColor()
            rainLabel.textColor = UIColor.whiteColor()
        case .Night:
            backgroundColor = UIColor.blackColor()
            dayLabel.textColor = UIColor.whiteColor()
            minsLabel.textColor = UIColor.whiteColor()
            timeLabel.textColor = UIColor.whiteColor()
            tempLabel.textColor = UIColor.whiteColor()
            CFLabel.textColor = UIColor.whiteColor()
            rainLabel.textColor = UIColor.whiteColor()
        }
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
                let alertController = UIAlertController(title: "Current Weather", message: "No icon found for weather condition: '\(iconName).\n\nHence the 'alien' face.", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(okAction)
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
                image = UIImage(named: "sun.png")!
            }
        } else {
            let alertController = UIAlertController(title: "Current Weather", message: "No weather condition icon selector supplied by the forecast.  Hence the circle.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
            image = UIImage(named: "sun.png")!
        }
        return image
    }

    private func dayStringFromUnixTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEEEE"  // 2 letter day.
        return dateFormatter.stringFromDate(date)
    }

    private func timeStringFromUnixTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH"
        return dateFormatter.stringFromDate(date)
    }

}

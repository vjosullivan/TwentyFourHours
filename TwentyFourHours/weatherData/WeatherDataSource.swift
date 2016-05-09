//
//  WeatherDataSource.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 16/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class WeatherDataSource:  NSObject {

    private let days:  [DayLine]
    private let hours: [[WeatherLine]]

    init(display: ForecastIOHourlyDisplay) {
        self.days  = display.dailyLines
        self.hours = display.hourlyLines
    }
}

extension WeatherDataSource: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return days.count
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return days[section].text
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hours[section].count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HourCell") as! WeatherTableViewCell

        cell.configure(rowIndex: indexPath.row, displayLine: hours[indexPath.section][indexPath.row])
        return cell
    }
}

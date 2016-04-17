//
//  WeatherDataSource.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 16/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class WeatherDataSource:  NSObject, UITableViewDataSource {

    private let forecast: Forecast

    init(forecast: Forecast) {
        self.forecast = forecast
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.oneHourForecasts?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HourCell")! as! WeatherTableViewCell

        cell.configure(rowIndex: indexPath.row, forecast: forecast)
        return cell
    }
}

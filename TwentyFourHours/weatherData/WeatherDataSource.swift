//
//  WeatherDataSource.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 16/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class WeatherDataSource:  NSObject {

    private let forecast: Forecast
    private let displayableForecast: DisplayableForecast

    private var selectedIndexPath: NSIndexPath?

    init(forecast: Forecast) {
        self.forecast = forecast
        self.displayableForecast = DisplayableForecast(forecast: forecast)
        super.init()
    }
}

extension WeatherDataSource: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return displayableForecast.dayCount
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayableForecast.rowCount(inDay: section)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if indexPath == selectedIndexPath {
            print("A")
            cell = tableView.dequeueReusableCellWithIdentifier("HourDetailCell") as! WeatherDetailTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            (cell as! WeatherDetailTableViewCell).configure(displayableForecast.forecast(day: indexPath.section, line: indexPath.row))
        } else {
            print("B i=\(indexPath); e=\(selectedIndexPath)")
            cell = tableView.dequeueReusableCellWithIdentifier("HourCell") as! WeatherTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            (cell as! WeatherTableViewCell).configure(displayableForecast.forecast(day: indexPath.section, line: indexPath.row))
        }
        return cell
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE, d MMMM"
        return formatter.stringFromDate(displayableForecast.forecast(day: section, line: 0).date)
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Wahey!")
        tableView.beginUpdates()
        if selectedIndexPath != indexPath {
            print("C")
            let paths = selectedIndexPath != nil ? [selectedIndexPath!, indexPath] : [indexPath]

            tableView.reloadRowsAtIndexPaths(paths, withRowAnimation: .Automatic)
            selectedIndexPath = indexPath
        } else {
            print("D")
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            selectedIndexPath = nil
        }
        tableView.endUpdates()
    }

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        print("Wahoo!")
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (selectedIndexPath == indexPath) ? 132.0 : 44.0
    }
}

extension WeatherDataSource: UITableViewDelegate {

    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.blackColor()

        let headerView: UITableViewHeaderFooterView  = view as! UITableViewHeaderFooterView
        headerView.textLabel!.textColor = UIColor.orangeColor()
        let font = headerView.textLabel!.font
        headerView.textLabel!.font = font.bold()
    }
}

extension UIFont {

    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor()
            .fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor, size: 0)
    }

    func bold() -> UIFont {
        return withTraits(.TraitBold)
    }
}

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

    private var selectedIndexPath: IndexPath?

    init(forecast: Forecast) {
        self.forecast = forecast
        self.displayableForecast = DisplayableForecast(forecast: forecast)
        super.init()
    }
}

extension WeatherDataSource: UITableViewDataSource {

    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return displayableForecast.dayCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayableForecast.rowCount(inDay: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if indexPath == selectedIndexPath {
            print("A")
            cell = tableView.dequeueReusableCell(withIdentifier: "HourDetailCell") as! WeatherDetailTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            (cell as! WeatherDetailTableViewCell).configure(datapoint: displayableForecast.forecast(day: indexPath.section, line: indexPath.row))
        } else {
            print("B i=\(indexPath); e=\(selectedIndexPath)")
            cell = tableView.dequeueReusableCell(withIdentifier: "HourCell") as! WeatherTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            (cell as! WeatherTableViewCell).configure(datapoint: displayableForecast.forecast(day: indexPath.section, line: indexPath.row))
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM"
        return formatter.string(from: displayableForecast.forecast(day: section, line: 0).date)
    }

    @objc(tableView:didSelectRowAtIndexPath:) internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Wahey!")
        tableView.beginUpdates()
        if selectedIndexPath != indexPath {
            print("C")
            let paths = selectedIndexPath != nil ? [selectedIndexPath!, indexPath] : [indexPath]

            tableView.reloadRows(at: paths, with: .automatic)
            selectedIndexPath = indexPath
        } else {
            print("D")
            tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.deselectRow(at: indexPath, animated: true)
            selectedIndexPath = nil
        }
        tableView.endUpdates()
    }

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: IndexPath) {
        print("Wahoo!")
    }

    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (selectedIndexPath == indexPath) ? 132.0 : 44.0
    }
}

extension WeatherDataSource: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.black()

        let headerView: UITableViewHeaderFooterView  = view as! UITableViewHeaderFooterView
        headerView.textLabel!.textColor = UIColor.orange()
        headerView.textLabel!.font = headerView.textLabel!.font!.bold()
    }
}

extension UIFont {

    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor().withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
}

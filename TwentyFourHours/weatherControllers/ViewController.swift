//
//  ViewController.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 14/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var weatherTable: UITableView!

    var forecastIOManager: ForecastIOManager?
    
    private var weatherData: WeatherDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        forecastIOManager = ForecastIOManager(forecastDelegate: self)
        forecastIOManager!.updateForecast()
    }

    private func updateView(forecast forecast: Forecast) {
        weatherData = WeatherDataSource(forecast: forecast)
        weatherTable.dataSource = weatherData
        weatherTable.reloadData()
    }
}

extension ViewController: ForecastManagerDelegate {

    func forecastManager(manager: ForecastIOManager, didUpdateForecast forecast: Forecast) {
        dispatch_async(dispatch_get_main_queue()) {
            self.updateView(forecast: forecast)
        }
    }

    func forecastManager(manager: ForecastIOManager, didFailWithError error: NSError) {
        dispatch_async(dispatch_get_main_queue()) {
            self.updateView(forecast: nilForecast)
        }
        let alertController = UIAlertController(title: "Current Weather", message: "No weather forecast available at the moment.\n\n\(error)", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
//
//  ViewController.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 14/04/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var weatherTable: UITableView!
    
    private var weatherData: WeatherDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        weatherTable.delegate = self

        ForecastIOManager(delegate: self).updateForecast()
    }

    func updateView(forecast forecast: Forecast) {
        print("Updating view...")
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
        let alertController = UIAlertController(title: "Current Weather", message: "No weather forecast available at the moment.\n\n\(error)", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
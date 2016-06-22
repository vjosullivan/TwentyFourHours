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

    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var currentIcon: UIImageView!
    @IBOutlet weak var currentSummary: UILabel!

    @IBOutlet weak var weatherTable: UITableView!
    
    private var weatherData: WeatherDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        ForecastIOAPIClient(forecastDelegate: self).updateForecast()
    }

    ///  Update the view with the current weather forecast.
    ///
    private func updateView(forecast: Forecast) {
        weatherData = WeatherDataSource(forecast: forecast)
        weatherTable.dataSource = weatherData
        weatherTable.delegate   = weatherData
        weatherTable.reloadData()

        if let temperature = forecast.currentConditions?.temperature {
            currentTemperature.text = String(Int(round(temperature)))
        } else {
            currentTemperature.text = ""
        }

        currentIcon.image = weatherImage(iconName: forecast.currentConditions?.icon)
        currentSummary.text = forecast.currentConditions?.summary ?? ""
    }

    func weatherImage(iconName: String?) -> UIImage {
        guard let foundImage = UIImage(named: iconName!) else {
            return UIImage(named: "unknown")!
        }
        return foundImage
    }
}

extension ViewController: ForecastIOAPIClientDelegate {

    func forecast(client: ForecastIOAPIClient, didUpdateForecast forecast: Forecast) {
        DispatchQueue.main.async {
            self.updateView(forecast: forecast)
        }
    }

    func forecast(client: ForecastIOAPIClient, didFailWithError error: NSError) {
        DispatchQueue.main.async {
            self.updateView(forecast: nilForecast)
        }
        let alertController = UIAlertController(title: "Current Weather", message: "No weather forecast available at the moment.\n\n\(error)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

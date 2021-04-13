//
//  ViewController.swift
//  WeatherApp
//
//  Created by Kuliza-277 on 12/04/21.
//  Copyright © 2021 Pratice. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherMainViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var weatherConditionalImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    var searchedPlace = ""
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    
    @IBAction func locationMeClicked(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    @IBAction func searchPressed(_ sender: UIButton) {
        searchFunction()
    }
    
    func searchFunction(){
        searchTextField.endEditing(true)
        placeLabel.text = searchedPlace
    }
}

//MARK: - UITextField Delegate

extension WeatherMainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchFunction()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == searchTextField {
            searchedPlace = searchTextField.text!
            weatherManager.fetchWeather(searchedPlace)
            searchTextField.text = ""
        }
    }
}

//MARK: - Weather Manager Delegate
extension WeatherMainViewController :WeatherManagerDelegate {
    func didUpdateWeather(_ weatherModel: WeatherManager,weather: WeatherModel) {
        DispatchQueue.main.async {
            self.tempLabel.text = weather.tempratureString
            self.placeLabel.text = weather.cityName
            self.weatherConditionalImage.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
//MARK: - CLLocationManager Delegate

extension WeatherMainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(lat, lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

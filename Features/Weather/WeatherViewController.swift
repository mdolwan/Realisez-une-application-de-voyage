//
//  WeatherViewController.swift
//  Baluchon
//
//  Created by Mohammad Olwan on 01/02/2022.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    @IBOutlet weak var citySegmentedControl: UISegmentedControl!
    
    let weatherRepository = WeatherRepository()
          
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControlIsTapped(citySegmentedControl)
    }

    @IBAction func segmentedControlIsTapped(_ sender: UISegmentedControl) {
        let isYorktown = sender.selectedSegmentIndex == 0
        let selectedCity = isYorktown ? "yorktown" : "paris"
         
        weatherRepository.getWeatherData(city: selectedCity) { (weather) in
           
            guard let weather = weather else { return }
            
            DispatchQueue.main.async {
                self.mainLabel.text = weather.title
                self.descriptionLabel.text = weather.description
                self.pressureLabel.text = weather.pressure?.clean
                self.humidityLabel.text = weather.humidity?.clean
                self.temperatureLabel.text = weather.temperature?.clean
               }
            }
        }
   }





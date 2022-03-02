//
//  Weather.swift
//  Baluchon
//
//  Created by Mohammad Olwan on 01/02/2022.
//

import Foundation

//var arrayDeValues = [String]()
//let NotificationKey = "WeatherData"

class WeatherRepository {
    
    // var WeatherDataArray = [String]()
    private let baseUri_1: String = "https://api.openweathermap.org/data/2.5/weather?q="
    private let baseUri_2: String = "&lang=fr&appid=fd6e172787d9ad95090458c25d064653&units=imperial"
    var session = URLSession(configuration: .default)
    
    init() {}
    
    func getWeatherData(city: String, completion: @escaping (_ weather: Weather?) -> Void) {
        
        let baseUri = "\(baseUri_1)\(city)\(baseUri_2)"
        let url = URL(string: baseUri)
        
        let task = session.dataTask(with: url!, completionHandler: { (data: Data?, urlresponse: URLResponse?, error: Error?) in
            
            do {
                if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any],
                   let weather = json["main"] as? [String: Any],
                   let weatherInformation = try? JSONDecoder().decode(WeatherInformation.self, from: data),
                   let weatherDescription = weatherInformation.weather.first {
                    
                    let pressure = weather["pressure"] as? Double
                    let humidity = weather["humidity"] as? Double
                    let temperature = weather["temp"] as? Double
                    
                    let weather = Weather(
                        title: weatherDescription.title,
                        description: weatherDescription.details,
                        pressure: pressure,
                        humidity: humidity,
                        temperature: temperature
                    )
                    completion(weather)
                    return
                }
            }
            completion(nil)
        })
        task.resume()
    }
}


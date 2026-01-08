//
//  WeatherManager.swift
//  Clima
//
//  Created by Antonio Hernández Santander on 06/01/26.
//  Copyright © 2026 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let apiKey = "49f9cb17c7265c9a3a8922ef9e0d3cd9"
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String?, latitude: Double?, longitude: Double?) {
        var urlString: String!
        if let cityName = cityName {
            urlString = "\(weatherURL)&q=\(cityName)&appid=\(apiKey)"
        } else if let latitude = latitude, let longitude = longitude {
            urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
        }
        
        // print(urlString)
        perfomRequest(with: urlString)
    }
    
    func perfomRequest(with urlString: String) {
        // 1. Create a URL
        if let url = URL(string: urlString) {
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            // 3. Give the session a task
            // let task = session.dataTask(with: url, completionHandler: handle(data: response: error:))
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        // let weatherVC = WeatherViewController()
                        // weatherVC.didUpdateWeather(weather: weather)
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            // print("id: \(id), temp: \(temp), name: \(name)")
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            print ("conditionName: ", weather.conditionName)
            print("temperatureString: ", weather.temperatureString)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    /* func handle(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return 
        }
        
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString!)
        }
    } */
    
}

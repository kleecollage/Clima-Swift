//
//  WeatherManager.swift
//  Clima
//
//  Created by Antonio Hernández Santander on 06/01/26.
//  Copyright © 2026 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let apiKey = "49f9cb17c7265c9a3a8922ef9e0d3cd9"
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)&appid=\(apiKey)"
        // print(urlString)
        perfomRequest(urlString: urlString)
    }
    
    func perfomRequest(urlString: String) {
        // 1. Create a URL
        if let url = URL(string: urlString) {
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            // 3. Give the session a task
            // let task = session.dataTask(with: url, completionHandler: handle(data: response: error:))
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    self.parseJSON(weatherData: safeData)
                }
            }
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.main.temp)
            print(decodedData.weather[0].description)
        } catch {
            print(error)
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

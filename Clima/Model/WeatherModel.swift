//
//  WeatherModel.swift
//  Clima
//
//  Created by Antonio Hernández Santander on 07/01/26.
//  Copyright © 2026 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200..<300:
            return "cloud.bolt"
        case 300..<400:
            return "cloud.drizzle"
        case 500..<600:
            return "cloud.rain"
        case 600..<700:
            return "cloud.snow"
        case 700..<800:
            return "lines.measurement.vertical"
        case 800:
            return "sun.max"
        default:
            return "cloud"
        }
    }
}

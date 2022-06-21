//
//  WeatherModel.swift
//  iWeather
//
//  Created by Aakash Kumar on 26/05/22.
//

import Foundation

struct WeatherModel {
    let conditionID: Int
    let cityName: String
    let temperature: Double
    let minTemp: Double
    let maxTemp: Double
    let humidity: Int
    let description: String
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        switch conditionID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}

let example = WeatherModel(conditionID: 800, cityName: "London", temperature: 11.0, minTemp: 10.0, maxTemp: 21.0, humidity: 91, description: "Rain")

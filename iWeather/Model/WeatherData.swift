//
//  WeatherData.swift
//  iWeather
//
//  Created by Aakash Kumar on 26/05/22.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Int
}

struct Weather: Decodable {
    let id: Int
    let description: String
}

//
//  WeatherManager.swift
//  iWeather
//
//  Created by Aakash Kumar on 26/05/22.
//

import Foundation
import CoreLocation

//protocol WeatherManagerDelegate {
//    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
//    func didFailWithError(error: Error)
//}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=xxxxxxxx&units=metric"   //in xxxxxxxx add your own api id
    
//    var delegate: WeatherManagerDelegate?
    
    var error: Error?
    var weatherD: WeatherModel?
    
    func fetchWeather(cityName: String) async -> WeatherModel? {
        let urlString = "\(weatherURL)&q=\(cityName)"
        let weather = await performrequest(with: urlString)
        return weather
    }
    
    func fetchWeather(longitude: CLLocationDegrees, latitude: CLLocationDegrees) async -> WeatherModel? {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        let weather = await performrequest(with: urlString)
        return weather
    }
    
    func performrequest(with urlString: String) async -> WeatherModel? {
        var w: WeatherModel?
        if let url = URL(string: urlString) {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                w = parseJSON(data)
                return w
            } catch {
                print(error)
            }
        }
        return nil
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let minTemp = decodedData.main.temp_min
            let maxTemp = decodedData.main.temp_max
            let humidity = decodedData.main.humidity
            let description = decodedData.weather[0].description
            
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp, minTemp: minTemp, maxTemp: maxTemp, humidity: humidity, description: description)
            return weather
        } catch {
            print("ERROR OCCURRED!")
            return nil
        }
    }
    
}

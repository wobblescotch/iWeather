//
//  ContentView.swift
//  iWeather
//
//  Created by Aakash Kumar on 26/05/22.
//

import SwiftUI
import CoreLocation
import CoreLocationUI

struct ContentView: View {
    @Environment(\.colorScheme) var scheme
    @State private var locText = ""
    let weatherManager = WeatherManager()
    @State private var weatherModel = example
    @StateObject var locationManager = LocationManager()
    @FocusState private var foc: Bool
        
    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [Color(red: 0.21, green: 0.65, blue: 0.76), Color(UIColor.systemBackground)]), center: .center,
                           startRadius: 10, endRadius: 670)
            .ignoresSafeArea()
            
            
            VStack {
                HStack {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color("lightGray"))
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("Enter location", text: $locText)
                                .focused($foc)
                        }
                        .foregroundColor(.gray)
                        .padding(.leading, 13)
                    }
                    .frame(height: 40)
                    .cornerRadius(13)
                    
                    Button (action: {
                        Task {
                            foc = false
                            await searchButton()
                        }
                    }, label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.primary)
                            .font(.title)
                    })
                }
                
                Spacer()
                
                ScrollView {
                    VStack {
                        Spacer()
                        Text(weatherModel.cityName)
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                        
                        VStack(spacing: 15) {
                            VStack(spacing: 15) {
                                Image(systemName: "\(weatherModel.conditionName)")
                                    .foregroundStyle(.secondary)
                                    .font(.largeTitle.weight(.heavy))
                                
                                Text("\(weatherModel.temperatureString)° C")
                                    .font(.largeTitle.weight(.semibold))
                            }
                            
                            Text(weatherModel.description.capitalized)
                                .font(.title2)
                            
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        
                        
                        HStack {
                            VStack {
                                Text("Max: \(String(format: "%.1f", weatherModel.maxTemp))°")
                                    .font(.title2)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            
                            VStack {
                                Text("Min: \(String(format: "%.1f", weatherModel.minTemp))°")
                                    .font(.title2)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                        }
                        .padding(.vertical)
                        
                        VStack {
                            Text("Humidity: 90%")
                                .font(.title2)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                    }
                    .padding(.vertical, 30)
                }
                
                Spacer()
                Spacer()
                
                LocationButton(.shareCurrentLocation) {
                    Task {
                        foc = false
                        await currentLocationButton()
                    }
                }
                .cornerRadius(30)
                .labelStyle(.titleAndIcon)
                .symbolVariant(.fill)
                .foregroundColor(.white)
            }
            .padding()
        }
    }
    
    func currentLocationButton() async {
        locationManager.requestLocation()
        if let location = locationManager.location {
            let lat = location.latitude
            let lon = location.longitude
            print("\(lat) \(lon)")
            weatherModel = await weatherManager.fetchWeather(longitude: lon, latitude: lat) ?? example
        } else {
            if locationManager.isLoading {
                ProgressView()
            } else {
                locationManager.requestLocation()
            }
        }
    }
    
    func searchButton() async {
        weatherModel = await weatherManager.fetchWeather(cityName: locText) ?? example
        locText = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

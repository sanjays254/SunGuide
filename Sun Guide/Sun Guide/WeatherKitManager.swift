//
//  WeatherKitManager.swift
//  Sun Guide
//
//  Created by Sanjay Reck Mode on 2023-06-04.
//

import Foundation
import WeatherKit

@MainActor class WeatherKitManager: ObservableObject {
    
    @Published var weather: Weather?
    @Published var localizedSunTimes: LocalizedSunTimes? =  nil

    
    func getWeather() async {
        do {
            weather = try await Task.detached(priority: .userInitiated) {
                return try await WeatherService.shared.weather(for: .init(latitude: 37.322998, longitude: -122.032181))  // Coordinates for Apple Park just as example coordinates
            }.value
            
            
            if let sunEvents = weather?.dailyForecast.forecast[0].sun {
                
                if let sunrise = sunEvents.sunrise?.formatted(),
                   let sunset = sunEvents.sunset?.formatted(),
                   let midday = sunEvents.solarNoon?.formatted() {
                    self.localizedSunTimes = LocalizedSunTimes(sunrise: sunrise, sunset: sunset, midday: midday, dayLength: String((sunEvents.sunset!.timeIntervalSince1970 - sunEvents.sunrise!.timeIntervalSince1970)))
                }
            }
        } catch {
            fatalError("\(error)")
        }
    }
    
    var symbol: String {
        weather?.currentWeather.symbolName ?? "xmark"
    }
    
    var temp: String {
        let temp =
        weather?.currentWeather.temperature
        
        let convert = temp?.converted(to: .fahrenheit).description
        return convert ?? "Loading Weather Data"
        
    }
    
}

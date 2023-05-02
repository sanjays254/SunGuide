//
//  Network.swift
//  WidgetTests
//
//  Created by Sanjay Reck Mode on 2022-10-12.
//

import Foundation

import SwiftUI
import WidgetKit
import CoreLocation

class Network: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var sunTimes: SunTimes? = nil
    @Published var localizedSunTimes: LocalizedSunTimes? =  nil
    
    @Published var location: CLLocation?
    @Published var city: String?
    
    private let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    let dateFormatter = ISO8601DateFormatter()
        
    override init() {
        super.init()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getTimes(completion: ((_ sunriseDegrees: Double, _ sunsetDegrees: Double) -> ())? = nil) {
        guard let location = location else { return }

        let date = Date().formatted(date: .numeric, time: .omitted)

        guard let url = URL(string: "https://api.sunrise-sunset.org/json?lat=\(location.coordinate.latitude)&lng=\(location.coordinate.longitude)&date=\(date)&formatted=0") else { fatalError()}
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                
                print("Request error:", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                
                DispatchQueue.main.async {
                    do {
                        let decodedObj = try JSONDecoder().decode(SunriseSunsetAPI.self, from: data)
                        self.sunTimes = decodedObj.results
                        self.localizedSunTimes = LocalizedSunTimes(sunrise: "X", sunset: "X", midday: "X", dayLength: "X")
                        
                        self.dateFormatter.timeZone = TimeZone.current
                        
                        if let sunsetTime = self.dateFormatter.date(from: decodedObj.results.sunset) {
                            self.localizedSunTimes?.sunset = self.dateFormatter.string(from: sunsetTime)
                        }
                        
                        if let sunriseTime = self.dateFormatter.date(from: decodedObj.results.sunrise) {
                            self.localizedSunTimes?.sunrise = self.dateFormatter.string(from: sunriseTime)
                        }
                        
                        
                        if let middayTime = self.dateFormatter.date(from: decodedObj.results.solar_noon) {
                            self.localizedSunTimes?.midday = self.dateFormatter.string(from: middayTime)
                        }
                        
                        
                        func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
                            return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
                        }
                        
                        let (h,m,s) = secondsToHoursMinutesSeconds(decodedObj.results.day_length)

                        let countdownString = String(format: "%dh %02dm %02ds", h, m, s)

                        
                        self.localizedSunTimes?.dayLength = countdownString
                        
                                                
 
                        // Get today's year, month and date
                        guard let date = self.dateFormatter.date(from: Date().ISO8601Format()) else {
                            return
                        }
                        
                        let formatter = DateFormatter()
                        formatter.timeZone = TimeZone.current
                        
                        formatter.dateFormat = "yyyy"
                        let year = formatter.string(from: date)
                        
                        formatter.dateFormat = "MM"
                        let month = formatter.string(from: date)
                        formatter.dateFormat = "dd"
                        let day = formatter.string(from: date)
                    
                        
                        if let timeZone = TimeZone.current.abbreviation() {
                            self.dateFormatter.timeZone = TimeZone(abbreviation: timeZone)
                        }
                        
                        
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let numberOfSecondsInOneDay: TimeInterval = 86400
                        guard let userDefaults = UserDefaults(suiteName: "group.ShahLabs.WidgetTests") else { return
                        }

                        // now interpolate the sunrise into degrees for widget
                        if let midnightUTC = formatter.date(from: "\(year)-\(month)-\(day) 00:00:00"),
                           let sunriseUTC = self.dateFormatter.date(from: decodedObj.results.sunrise),
                           let sunsetUTC = self.dateFormatter.date(from: decodedObj.results.sunset){
                            
                            
                            let secondsPassedFromMidnightToSunrise = sunriseUTC.timeIntervalSince(midnightUTC)
                            
                            let sunriseDegrees = secondsPassedFromMidnightToSunrise.interpolated(from: 0...numberOfSecondsInOneDay, to: 0...1)
                            
                            userDefaults.set(sunriseDegrees, forKey: "sunriseDegrees")
                            
                            
                            let secondsPassedFromMidnightToSunset = sunsetUTC.timeIntervalSince(midnightUTC)
                            
                            let sunsetDegrees = secondsPassedFromMidnightToSunset.interpolated(from: 0...numberOfSecondsInOneDay, to: 0...1)
                            
                            userDefaults.set(sunsetDegrees, forKey: "sunsetDegrees")
                            
                            if let completion = completion {
                                completion(sunriseDegrees, sunsetDegrees)
                            }
                            
                        }
                        WidgetCenter.shared.reloadAllTimelines()
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    
    
    
    func getCurrentCity() {
        if let location = location {
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
                placemarks?.forEach { (placemark) in
                    if let locality = placemark.locality {
                        self.city = locality
                    }
                }
            })
        } else {
            self.city = "Unknown location"
        }
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.location = location
            self.getCurrentCity()
            self.getTimes()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            print("notDetermined")
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("restricted")
            // Inform user about the restriction
            manager.requestWhenInUseAuthorization()
            
        case .denied:
            print("denied")
            // The user denied the use of location services for the app or they are disabled globally in Settings.
            // Direct them to re-enable this.
            break
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        default:
            print("unknown")
        }
    }
}


extension FloatingPoint {
    /// Allows mapping between reverse ranges, which are illegal to construct (e.g. `10..<0`).
    func interpolated(
        fromLowerBound: Self,
        fromUpperBound: Self,
        toLowerBound: Self,
        toUpperBound: Self) -> Self
    {
        let positionInRange = (self - fromLowerBound) / (fromUpperBound - fromLowerBound)
        return (positionInRange * (toUpperBound - toLowerBound)) + toLowerBound
    }
    
    func interpolated(from: ClosedRange<Self>, to: ClosedRange<Self>) -> Self {
        interpolated(
            fromLowerBound: from.lowerBound,
            fromUpperBound: from.upperBound,
            toLowerBound: to.lowerBound,
            toUpperBound: to.upperBound)
    }
}

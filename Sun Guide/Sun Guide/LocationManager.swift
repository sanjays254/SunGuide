//
//  LocationManager.swift
//  Sun Guide
//
//  Created by Sanjay Reck Mode on 2023-06-05.
//

import Foundation
import CoreLocation
import LogRocket

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocation?
    @Published var city: String?
    
    private let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    override init() {
        super.init()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
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
            Logger.error(message: "Failed to reverse geocode location.")
            self.city = "Unknown location"
        }
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            Logger.error(message: "last location is nil")
            return
        }
        DispatchQueue.main.async {
            self.location = location
            self.getCurrentCity()
//            self.getTimes()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Logger.error(message: "accessing location failed with error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            Logger.info(message: "location notDetermined")
            manager.requestWhenInUseAuthorization()
        case .restricted:
            Logger.info(message: "location restricted")
            // Inform user about the restriction
            manager.requestWhenInUseAuthorization()
            
        case .denied:
            Logger.info(message: "location denied")
            // The user denied the use of location services for the app or they are disabled globally in Settings.
            // Direct them to re-enable this.
            break
        case .authorizedAlways, .authorizedWhenInUse:
            // is this needed?
            manager.requestLocation()
        default:
            Logger.error(message: "unknown location status")
        }
    }
}

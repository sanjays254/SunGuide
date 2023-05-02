//
//  LocationManager.swift
//  WidgetTests
//
//  Created by Sanjay Reck Mode on 2022-12-08.
//

import Foundation
import CoreLocation


final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocation?
    @Published var city: String?

    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    let geoCoder = CLGeocoder()
    
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
            self.city = nil
        }
    }
    
    


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            DispatchQueue.main.async {
                self.location = location
                self.getCurrentCity()
                
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
            break
        case .denied:
            print("denied")
            // The user denied the use of location services for the app or they are disabled globally in Settings.
            // Direct them to re-enable this.
            break
        case .authorizedAlways, .authorizedWhenInUse:
            print("authorized")
            manager.requestLocation()
        @unknown default:
            break
        }
    }
}

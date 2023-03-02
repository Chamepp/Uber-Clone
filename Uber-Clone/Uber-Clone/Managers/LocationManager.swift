//
//  LocationManager.swift
//  Uber-Clone
//
//  Created by Ashkan Ebtekari on 3/1/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let location_manager = CLLocationManager()
    
    override init() {
        super.init()
        location_manager.delegate = self
        location_manager.desiredAccuracy = kCLLocationAccuracyBest
        location_manager.requestWhenInUseAuthorization()
        location_manager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !locations.isEmpty else { return }
        location_manager.stopUpdatingLocation()
    }
}

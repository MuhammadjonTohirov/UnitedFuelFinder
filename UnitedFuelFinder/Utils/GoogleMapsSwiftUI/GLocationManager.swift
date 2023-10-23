//
//  LocationManager.swift
//  UnitedFuelFinder
//
//  Created by applebro on 18/10/23.
//

import Foundation
import CoreLocation
import GoogleMaps

class GLocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = GLocationManager()
    private var locationManager = CLLocationManager()
    var locationUpdateHandler: ((CLLocation) -> Void)?
    
    var currentLocation: CLLocation? {
        locationManager.location
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func startUpdatingLocation() {
        DispatchQueue.global(qos: .utility).async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            } else {
                print("Location services are not enabled.")
                // Handle the case where location services are not enabled.
            }
        }
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationUpdateHandler?(location)
        }
    }
    
    func getAddressFromLatLon(latitude: Double, longitude: Double, completion: @escaping (String) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        GMSGeocoder().reverseGeocodeCoordinate(location.coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            
            let fullAddress = lines.joined(separator: ", ")
            completion(fullAddress)
        }
        
//        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
//            if let error = error {
//                print("Error: \(error)")
//                completion("Could not fetch address")
//            } else if let placemark = placemarks?.first {
//                var addressList: [String] = []
//                addressList.append(placemark.name ?? "")
//                addressList.append(placemark.locality ?? "")
//                addressList.append(placemark.administrativeArea ?? "")
//                addressList.append(placemark.isoCountryCode ?? "")
//                
//                let fullAddress = addressList.compactMap({$0.nilIfEmpty}).joined(separator: ", ")
//                completion(fullAddress)
//            }
//        }
    }
    
    func distance(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) -> Double {
        let sourceLocation = CLLocation(latitude: source.latitude, longitude: source.longitude)
        let destinationLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        
        // Calculate distance using Haversine formula
        let distanceInMeters = sourceLocation.distance(from: destinationLocation)
        
        // Convert distance from meters to kilometers
        let distanceInKilometers = distanceInMeters
        
        return distanceInKilometers
    }
}

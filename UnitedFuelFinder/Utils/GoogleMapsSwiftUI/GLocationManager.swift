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

    func fetchPlaces(forInput input: String, completion: @escaping (Result<[String], Error>) -> Void) {
        let apiKey = URL.googleMapsApiKey
        let inputType = "textquery" // or use 'geocode' for addresses only
        let baseUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?"

        guard let query = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "InvalidInput", code: 0, userInfo: nil)))
            return
        }

        let urlString = "\(baseUrl)input=\(query)&key=\(apiKey)&inputtype=\(inputType)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let predictions = json["predictions"] as? [[String: Any]] {
                    let addresses = predictions.compactMap { $0["description"] as? String }
                    completion(.success(addresses))
                } else {
                    completion(.failure(NSError(domain: "InvalidResponse", code: 0, userInfo: nil)))
                }
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }
        
        task.resume()
    }

    func getCoordinates(forAddress address: String, completion: @escaping (Result<(latitude: Double, longitude: Double), Error>) -> Void) {
        let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?address="
        let apiKey = URL.googleMapsApiKey // Replace with your actual API key

        guard let query = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "InvalidAddress", code: 0, userInfo: nil)))
            return
        }

        let urlString = "\(baseUrl)\(query)&key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let firstResult = results.first,
                   let geometry = firstResult["geometry"] as? [String: Any],
                   let location = geometry["location"] as? [String: Double],
                   let lat = location["lat"],
                   let lng = location["lng"] {
                    completion(.success((latitude: lat, longitude: lng)))
                } else {
                    completion(.failure(NSError(domain: "InvalidResponse", code: 0, userInfo: nil)))
                }
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }
        
        task.resume()
    }
}

struct PlaceInfo {
    let address: String
    let latitude: Double
    let longitude: Double
}

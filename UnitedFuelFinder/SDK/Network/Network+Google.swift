//
//  Network+Google.swift
//  UnitedFuelFinder
//
//  Created by applebro on 27/02/24.
//

import Foundation
import GoogleMaps
import CoreLocation

enum GoogleNetwork {
    static func getRoute(
        from: CLLocationCoordinate2D,
        to: CLLocationCoordinate2D,
        completion: @escaping (_ route: [CLLocationCoordinate2D]) -> Void
    ) {
        let origin = "\(from.latitude),\(from.longitude)"
        let destination = "\(to.latitude),\(to.longitude)"
        
        if let url = URL.googleRoutingAPI(from: origin, to: destination) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    debugPrint("Error fetching directions: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let routes = json?["routes"] as? [[String: Any]],
                       let route = routes.first,
                       let polyline = route["overview_polyline"] as? [String: Any],
                       let points = polyline["points"] as? String {
                        // Decode the polyline and draw it on the map
                        let path = GMSPath(fromEncodedPath: points)
                        var routeCoordinates = [CLLocationCoordinate2D]()
                        for i in 0..<path!.count() {
                            routeCoordinates.append(path!.coordinate(at: i))
                        }
                        completion(routeCoordinates)
                    } else {
                        completion([])
                    }
                } catch let error {
                    debugPrint("Error decoding directions: \(error.localizedDescription)")
                    completion([])
                }
            }.resume()
        }
    }
}

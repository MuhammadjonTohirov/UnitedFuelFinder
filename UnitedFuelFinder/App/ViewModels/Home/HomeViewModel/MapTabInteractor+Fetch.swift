//
//  MapTabInteractor+Fetch.swift
//  UnitedFuelFinder
//
//  Created by applebro on 24/06/24.
//

import Foundation
import CoreLocation

extension MapTabInteractor {
    func filterStationsByDefaultFromDatabase(
            _ filter: MapFilterInput,
            location: CLLocation,
            completion: @escaping ([StationItem]) -> Void
        ) {
            searchDispatchWork?.cancel()
            
            searchDispatchWork = .init(block: {
                var filteredStations = DStationItem.all?.filter
                
                { station in
                    let distance = location.distance(from: CLLocation(latitude: station.lat, longitude: station.lng)).f.asMile
                    return Int(distance) < filter.radius && filter.selectedStations.contains(station.customerId)
                }
                .filter { station in
                    if let stateId = filter.stateId?.nilIfEmpty {
                        return station.stateId == stateId
                    }
                    
                    if let cityId = filter.cityId {
                        return station.cityId == cityId
                    }
                    
                    return true
                }
                .filter { station in
                    let retailPrice = station.retailPrice ?? 0
                    let discount = station.discountPrice ?? 0
                    let actualPrice = retailPrice - discount
                    
                    return actualPrice > filter.from && actualPrice < filter.to
                }
                .map {
                    $0.asModel
                } ?? []
                
                for i in 0..<filteredStations.count {
                    let item = filteredStations[i]
                    item.distance = Float(location.distance(from: CLLocation(latitude: item.lat, longitude: item.lng)).f.asMile)
                    filteredStations[i].distance = item.distance
                }
                
                filteredStations = filteredStations.sorted(by: { st1, st2 in
                    switch filter.sortType {
                    case .distance:
                        return (st1.distance ?? 0) < (st2.distance ?? 0)
                    case .price:
                        return st1.actualPrice < st2.actualPrice
                    case .discount:
                        return (st1.retailPrice ?? 0) < (st2.retailPrice ?? 0)
                    }
                })
                
                debugPrint(filteredStations.compactMap({$0.distance}))
                
                filteredStations.forEach { station in
                    station.customer = DCustomer.all?.filter("id = %d", station.customerId).first?.asModel
                    station.state = .init(id: station.stateId ?? "", name: station.stateName ?? "")
                    station.city = .init(id: station.cityId ?? -1, 
                                         stateId: station.stateId ?? "",
                                         name: station.cityName ?? "",
                                         lat: station.lat,
                                         lng: station.lng,
                                         timezone: nil)
                }

                let isCancelled = self.searchDispatchWork?.isCancelled ?? false
                
                if !isCancelled {
                    debugPrint("Filter stations in \(filter.radius) at \(location.coordinate)")
                    completion(filteredStations)
                }

            })

            DispatchQueue.global(qos: .utility).async {
                self.searchDispatchWork?.perform()
            }
        }
}

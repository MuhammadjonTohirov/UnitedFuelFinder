//
//  Array+StationItem+Extension.swift
//  UnitedFuelFinder
//
//  Created by applebro on 22/02/24.
//

import Foundation

extension Array where Element == StationItem {
    func applyFilter(_ filter: MapFilterInput) -> [Element] {
        self.filter { item in
            let price = item.retailPrice ?? 0
            let from = Float(filter.from)
            let to = Float(filter.to)
            
            let isValidPrice = price >= from && price <= to
            let isValidStation = filter.selectedStations.contains(item.customerId)
            
            let isValidState = filter.stateId == nil ? true : item.stateId == filter.stateId
            let isValidCity = filter.cityId == nil ? true : item.cityId == filter.cityId
            
            return isValidPrice && isValidStation && isValidCity && isValidState
        }
        .sorted(by: { a, b in
            if filter.sortType == .discount {
                return a.distanceFromCurrentLocation < b.distanceFromCurrentLocation
            } else if filter.sortType == .price {
                return (a.retailPrice ?? 0) < (b.retailPrice ?? 0)
            } else {
                return true
            }
        })
    }
    
    func applySort(_ filter: MapFilterInput) -> [Element] {
        self.sorted(by: { a, b in
            switch filter.sortType {
            case .discount:
                return (a.discountPrice ?? 0) > (b.discountPrice ?? 0)
            case .distance:
                return (a.distance ?? 0) < (b.distance ?? 0)
            case .price:
                return (a.retailPrice ?? 0) < (b.retailPrice ?? 0)
            }
        })
    }
}

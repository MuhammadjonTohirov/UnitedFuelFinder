//
//  Array+StationItem+Extension.swift
//  UnitedFuelFinder
//
//  Created by applebro on 22/02/24.
//

import Foundation

extension Array where Element == StationItem {
    func applyFilter(_ filter: MapFilterInput) -> [Element] {
        var filteredStations = self
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
        
        filteredStations = filteredStations.sorted(by: { st1, st2 in
            switch filter.sortType {
            case .distance:
                return (st1.distance ?? 0) < (st2.distance ?? 0)
            case .price:
                return (st1.retailPrice ?? 0) < (st2.retailPrice ?? 0)
            case .discount:
                return st1.actualPrice < st2.actualPrice
            }
        })
        
        return filteredStations
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

//
//  StationItem.swift
//  UnitedFuelFinder
//
//  Created by applebro on 30/10/23.
//

import Foundation
import RealmSwift
import GoogleMaps
import CoreLocation
import SwiftUI

public class StationItem: Identifiable {
    public var id: Int
    public var name: String
    public var lat: Double
    public var lng: Double
    public var isDeleted: Bool
    public var cityId: Int?
    public var customerId: Int
    public var address: String?
    public var phone: String?
    public var stateId: String?
    public var discountPrice: Float?
    public var retailPrice: Float?
    public var logoUrl: String?
    public var note: String?
    public var number: String?
    public var priceUpdated: String?
    public var distance: Float?
    public var cityName: String?
    public var stateName: String?
    
    public var displayName: String?
    
    public var identifier: String?
    public var isEmpty: Bool?
    public var isOpen: Bool?
    public var bestPrice: Float?
    public var customerName: String?
    
    public var actualPriceInfo: String {
        return actualPrice.asMoney
    }
    
    public var actualPrice: Float {
        (retailPrice ?? 0) - (discountPrice ?? 0)
    }
    
    public var retailPriceInfo: String {
        retailPrice?.asMoney ?? "$0"
    }
    
    public var discountInfo: String {
        (discountPrice ?? 0).asMoney
    }
    
    public init(id: Int, name: String, lat: Double, lng: Double, isDeleted: Bool, cityId: Int, customerId: Int, address: String? = nil, phone: String? = nil, stateId: String?, discountPrice: Float? = nil, retailPrice: Float? = nil, priceUpdated: String?, note: String?, distance: Float? = 0) {
        self.id = id
        self.name = name
        self.lat = lat
        self.lng = lng
        self.isDeleted = isDeleted
        self.cityId = cityId
        self.customerId = customerId
        self.address = address
        self.phone = phone
        self.stateId = stateId
        self.discountPrice = discountPrice
        self.retailPrice = retailPrice
        self.priceUpdated = priceUpdated
        self.note = note
        self.distance = distance
    }
    
    init(res item: NetResStationItem) {
        self.id = item.id
        self.name = item.name
        self.lat = item.lat
        self.lng = item.lng
        self.isDeleted = item.isDeleted ?? false
        self.cityId = item.cityId
        self.customerId = item.customerId
        self.address = item.address
        self.phone = item.phone
        self.stateId = item.stateId
        self.discountPrice = item.discountPrice
        self.retailPrice = item.retailPrice
        self.logoUrl = item.logoUrl
        self.priceUpdated = item.priceUpdated
        self.note = item.note
        self.number = item.number
        self.distance = item.distance
        self.cityName = item.cityName
        self.stateName = item.stateName
        self.identifier = item.identifier
        self.isEmpty = item.isEmpty
        self.isOpen = item.isOpen
        self.bestPrice = item.bestPrice
        self.customerName = item.customerName
        
        let customerName = self.name.replacingOccurrences(of: self.number ?? "-1", with: "")
        self.displayName = (customerName + " " + (self.number ?? "")).nilIfEmpty ?? self.name
    }
    
    var customer: CustomerItem?
    var city: CityItem?
    var state: StateItem?
}

extension StationItem {
    /// finds distance as mile
    private func _distance(from coordinate: CLLocationCoordinate2D) -> Double {
        Double(GMSGeometryDistance(self.asMarker.position, coordinate).f.asMile)
    }
    
    var distanceFromCurrentLocation: Double {
        let coordinate = GLocationManager.shared.currentLocation?.coordinate ?? .init(latitude: 0, longitude: 0)
        return Double(GMSGeometryDistance(self.coordinate, coordinate))
    }
    
    var distanceFromCurrentLocationInfo: String {
        guard let distance, distance != 0 else {
            let coordinate = GLocationManager.shared.currentLocation?.coordinate ?? .init(latitude: 0, longitude: 0)
            return distanceInfo(_distance(from: coordinate).asFloat)
        }
        
        return distanceInfo(Float(CGFloat(distance)))
    }
    
    var coordinate: CLLocationCoordinate2D {
        .init(latitude: self.lat, longitude: self.lng)
    }
    
    private func distanceInfo(_ dist: Float) -> String {
        return String(format: "%.2f", dist) + " ml"
    }
    
    var fullAddress: String {
        return [address ?? "", cityName ?? "", stateName ?? ""].compactMap({$0.nilIfEmpty}).joined(separator: ", ")
    }
}

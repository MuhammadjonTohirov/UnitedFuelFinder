//
//  StationItem.swift
//  UnitedFuelFinder
//
//  Created by applebro on 30/10/23.
//

import Foundation
import RealmSwift
import GoogleMaps

public struct StationItem: Identifiable {
    public var id: Int
    public var name: String
    public var lat: Double
    public var lng: Double
    public var isDeleted: Bool
    public var cityId: Int
    public var customerId: Int
    public var address: String?
    public var phone: String?
    public var stateId: String?
    public var discountPercent: Float?
    public var retailPrice: Float?
    public var iconUrl: String?
    
    public var actualPriceInfo: String {
        ((retailPrice ?? 0) - ((discountPercent ?? 0) / 100 * (retailPrice ?? 0))).asMoney
    }
    
    public var retailPriceInfo: String {
        retailPrice?.asMoney ?? "$0"
    }
    
    public var discountInfo: String {
        ((discountPercent ?? 0) / 100 * (retailPrice ?? 0)).asMoney
    }
    
    public init(id: Int, name: String, lat: Double, lng: Double, isDeleted: Bool, cityId: Int, customerId: Int, address: String? = nil, phone: String? = nil, stateId: String?, discountPercent: Float? = nil, retailPrice: Float? = nil) {
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
        self.discountPercent = discountPercent
        self.retailPrice = retailPrice
    }
    
    init(res item: NetResStationItem) {
        self.id = item.id
        self.name = item.name
        self.lat = item.lat
        self.lng = item.lng
        self.isDeleted = item.isDeleted
        self.cityId = item.cityId
        self.customerId = item.customerId
        self.address = item.address
        self.phone = item.phone
        self.stateId = item.stateId
        self.discountPercent = item.discountPercent
        self.retailPrice = item.retailPrice
        self.iconUrl = item.iconUrl
    }
}

fileprivate let _imageView: MarkerImageView = MarkerImageView.create(url: nil, placeholder: UIImage(named: "icon_station1"))

public extension StationItem {
    var asMarker: GMSMarker {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng)
        marker.title = self.name
        marker.snippet = self.address
        marker.iconView = _imageView
        marker.iconView?.frame.size = .init(width: 32, height: 32)
        marker.station = self
        return marker
    }
    
    var city: DCity? {
        Realm.new?.object(ofType: DCity.self, forPrimaryKey: self.cityId)
    }
    
    var state: DState? {
        guard let stateId = self.stateId else {
            return nil
        }
        
        return Realm.new?.object(ofType: DState.self, forPrimaryKey: stateId)
    }
    
    func distance(from coordinate: CLLocationCoordinate2D) -> Double {
        GMSGeometryDistance(self.asMarker.position, coordinate)
    }
    
    func distanceInfo(from coordinate: CLLocationCoordinate2D?) -> String {
        guard let c = coordinate else {
            return ""
        }
        
        let distance = distance(from: c)
        let isMore1000 = Int(distance) / 1000 > 0
        let unit = isMore1000 ? "km" : "m"
        
        return String(format: "%.1f \(unit)",  isMore1000 ? distance / 1000 : distance)
    }
}

public extension GMSMarker {
    var station: StationItem? {
        set(station) {
            self.userData = station
        }
        
        get {
            self.userData as? StationItem
        }
    }
}

//
//  StationItem.swift
//  UnitedFuelFinder
//
//  Created by applebro on 30/10/23.
//

import Foundation
import RealmSwift
import GoogleMaps

struct StationItem: NetResBody, Identifiable {
    var id: Int
    var name: String
    var lat: Double
    var lng: Double
    var isDeleted: Bool
    var cityId: Int
    var customerId: Int
    var address: String?
    var phone: String?
    var stateId: String
    var discountPercent: Float?
    var retailPrice: Float?
    var iconUrl: String?
    
    var actualPriceInfo: String {
        ((retailPrice ?? 0) - ((discountPercent ?? 0) / 100 * (retailPrice ?? 0))).asMoney
    }
    
    var retailPriceInfo: String {
        retailPrice?.asMoney ?? "$0"
    }
    
    var discountInfo: String {
        ((discountPercent ?? 0) / 100 * (retailPrice ?? 0)).asMoney
    }
    
    init(id: Int, name: String, lat: Double, lng: Double, isDeleted: Bool, cityId: Int, customerId: Int, address: String? = nil, phone: String? = nil, stateId: String, discountPercent: Float? = nil, retailPrice: Float? = nil) {
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
extension StationItem {
    var asMarker: GMSMarker {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng)
        marker.title = self.name
        marker.snippet = self.address
        marker.iconView = _imageView
        marker.iconView?.frame.size = .init(width: 32, height: 32)
        return marker
    }
    
    var city: DCity? {
        Realm.new?.object(ofType: DCity.self, forPrimaryKey: self.cityId)
    }
    
    var state: DState? {
        Realm.new?.object(ofType: DState.self, forPrimaryKey: self.stateId)
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

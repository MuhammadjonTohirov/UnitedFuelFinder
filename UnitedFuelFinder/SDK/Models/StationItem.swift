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
    public var discountPrice: Float?
    public var retailPrice: Float?
    public var logoUrl: String?
    public var note: String?
    public var priceUpdated: String?
    
    public var actualPriceInfo: String {
        discountPrice?.asMoney ?? "$0"
    }
    
    public var retailPriceInfo: String {
        retailPrice?.asMoney ?? "$0"
    }
    
    public var discountInfo: String {
        ((retailPrice ?? 0) - (discountPrice ?? 0)).asMoney
    }
    
    public init(id: Int, name: String, lat: Double, lng: Double, isDeleted: Bool, cityId: Int, customerId: Int, address: String? = nil, phone: String? = nil, stateId: String?, discountPrice: Float? = nil, retailPrice: Float? = nil, priceUpdated: String?, note: String?) {
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
        self.discountPrice = item.discountPrice
        self.retailPrice = item.retailPrice
        self.logoUrl = item.logoUrl
        self.priceUpdated = item.priceUpdated
        self.note = item.note
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
        Double(GMSGeometryDistance(self.asMarker.position, coordinate).f.asMile)
    }
    
    var distanceFromCurrentLocation: Double {
        let coordinate = GLocationManager.shared.currentLocation?.coordinate ?? .init(latitude: 0, longitude: 0)
        return Double(GMSGeometryDistance(self.coordinate, coordinate).f.asMile)
    }
    
    var coordinate: CLLocationCoordinate2D {
        .init(latitude: self.lat, longitude: self.lng)
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

extension GMSMarker: Identifiable {
    public var id: String {
        "\(self.position.latitude)-\(self.position.longitude)"
    }
    
    var station: StationItem? {
        set(station) {
            self.userData = station
        }
        
        get {
            self.userData as? StationItem
        }
    }
}

extension StationItem {
    var trustedDiscountPrice: Float {
        self.discountPrice ?? 0
    }
    
    //    priceUpdateDate with format "2023-11-19T06:13:47.785Z"
    public var priceUpdateDate: Date? {
        guard let priceUpdated = self.priceUpdated else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter.date(from: priceUpdated)
    }
    
    //        format 11/15/2023 22:51:49
    public var priceUpdateInfo: String {
        guard let date = priceUpdateDate else { return "" }
        return date.toExtendedString(format: "MM/dd/yyyy HH:mm:ss")
    }
}

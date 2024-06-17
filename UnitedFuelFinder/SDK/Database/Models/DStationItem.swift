//
//  DStationItem.swift
//  UnitedFuelFinder
//
//  Created by applebro on 12/03/24.
//

import Foundation
import RealmSwift

class DStationItem: Object, Identifiable {
    @Persisted(primaryKey: true) public var id: Int
    @Persisted public var name: String
    @Persisted public var lat: Double
    @Persisted public var lng: Double
    @Persisted public var isDeleted: Bool
    @Persisted public var cityId: Int?
    @Persisted public var customerId: Int
    @Persisted public var address: String?
    @Persisted public var phone: String?
    @Persisted public var stateId: String?
    @Persisted public var discountPrice: Float?
    @Persisted public var retailPrice: Float?
    @Persisted public var logoUrl: String?
    @Persisted public var note: String?
    @Persisted public var number: String?
    @Persisted public var priceUpdated: String?
    @Persisted public var distance: Float?
    @Persisted public var cityName: String?
    @Persisted public var stateName: String?
    @Persisted public var identifier: String?
    @Persisted public var isEmpty: Bool?
    @Persisted public var isOpen: Bool?
    @Persisted public var bestPrice: Float?
    @Persisted public var customerName: String?
}

extension DStationItem {
    var asModel: StationItem {
        var st: StationItem = .init(
            id: id,
            name: name,
            lat: lat,
            lng: lng,
            isDeleted: isDeleted,
            cityId: cityId ?? -1,
            customerId: customerId,
            address: address,
            phone: phone,
            stateId: stateId,
            discountPrice: discountPrice,
            retailPrice: retailPrice,
            priceUpdated: priceUpdated,
            note: note,
            distance: distance
        )
        st.number = self.number
        st.stateName = self.stateName
        st.cityName = self.cityName
        let customerName = self.name.replacingOccurrences(of: self.number ?? "-1", with: "")
        st.displayName = (customerName + " " + (st.number ?? "")).nilIfEmpty ?? self.name
        st.identifier = self.identifier
        st.isEmpty = self.isEmpty
        st.isOpen = self.isOpen
        st.bestPrice = self.bestPrice
        return st
    }
    
    // crud
    static func create(_ item: NetResStationItem) -> DStationItem {
        let dStationItem = DStationItem()
        dStationItem.id = item.id
        dStationItem.name = item.name
        dStationItem.lat = item.lat
        dStationItem.lng = item.lng
        dStationItem.isDeleted = item.isDeleted ?? false
        dStationItem.cityId = item.cityId
        dStationItem.cityName = item.cityName
        dStationItem.customerId = item.customerId
        dStationItem.address = item.address
        dStationItem.phone = item.phone
        dStationItem.stateId = item.stateId
        dStationItem.stateName = item.stateName
        
        dStationItem.discountPrice = item.discountPrice
        dStationItem.priceUpdated = item.priceUpdated
        dStationItem.retailPrice = item.retailPrice
        
        dStationItem.number = item.number
        dStationItem.logoUrl = item.logoUrl
        dStationItem.note = item.note
        dStationItem.distance = item.distance
        dStationItem.identifier = item.identifier
        dStationItem.isEmpty = item.isEmpty
        dStationItem.isOpen = item.isOpen
        dStationItem.bestPrice = item.bestPrice
        dStationItem.customerName = item.customerName
        return dStationItem
    }
    
    static func create(_ item: StationItem) -> DStationItem {
        let dStationItem = DStationItem()
        dStationItem.id = item.id
        dStationItem.name = item.name
        dStationItem.lat = item.lat
        dStationItem.lng = item.lng
        dStationItem.isDeleted = item.isDeleted
        dStationItem.cityId = item.cityId
        dStationItem.customerId = item.customerId
        dStationItem.address = item.address
        dStationItem.phone = item.phone
        dStationItem.stateId = item.stateId
        dStationItem.discountPrice = item.discountPrice
        dStationItem.priceUpdated = item.priceUpdated
        dStationItem.retailPrice = item.retailPrice
        dStationItem.logoUrl = item.logoUrl
        dStationItem.note = item.note
        dStationItem.number = item.number
        dStationItem.distance = item.distance
        dStationItem.cityName = item.cityName
        dStationItem.stateName = item.stateName
        dStationItem.identifier = item.identifier
        dStationItem.isEmpty = item.isEmpty
        dStationItem.isOpen = item.isOpen
        dStationItem.bestPrice = item.bestPrice
        dStationItem.customerName = item.customerName
        return dStationItem
    }
    
    static var all: Results<DStationItem>? {
        return Realm.new?.objects(DStationItem.self)
    }
    
    static func find(_ id: Int) -> DStationItem? {
        return Realm.new?.object(ofType: DStationItem.self, forPrimaryKey: id)
    }
    
    static func insert(_ item: DStationItem) {
        try! Realm.new?.write {
            Realm.new?.add(item, update: .modified)
        }
    }
    
    static func insertAll(_ items: [DStationItem]) {
        Realm.new?.trySafeWrite { realm in
            realm.add(items, update: .modified)
        }
    }
    
    static func deleteAll() {
        Realm.new?.trySafeWrite { realm in
            realm.delete(realm.objects(DStationItem.self))
        }
    }
}

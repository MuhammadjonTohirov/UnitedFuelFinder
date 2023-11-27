//
//  DCustomer.swift
//  UnitedFuelFinder
//
//  Created by applebro on 26/11/23.
//

import Foundation
import RealmSwift

class DCustomer: Object, Identifiable {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var name: String = ""
    @Persisted var email: String?
    @Persisted var phone: String?
    @Persisted var cityId: Int?
    @Persisted var stateId: String?
    @Persisted var address: String?
    @Persisted var isDeleted: Bool = false
    @Persisted var iconUrl: String?
    @Persisted var logoUrl: String?
    @Persisted var markerColor: String?
    
    convenience init(item: CustomerItem) {
        self.init()
        self.id = item.id
        self.name = item.name
        self.email = item.email
        self.phone = item.phone
        self.cityId = item.cityId
        self.stateId = item.stateId
        self.address = item.address
        self.isDeleted = item.isDeleted ?? false
        self.iconUrl = item.iconUrl
        self.logoUrl = item.logoUrl
        self.markerColor = item.markerColor
    }
    
    override init() {
        super.init()
    }
    
    func toNetResCustomerItem() -> NetResCustomerItem {
        return NetResCustomerItem(id: self.id, name: self.name, email: self.email, phone: self.phone, cityId: self.cityId, stateId: self.stateId, address: self.address, isDeleted: self.isDeleted, iconUrl: self.iconUrl, logoUrl: self.logoUrl, markerColor: self.markerColor)
    }
    
    func toCustomerItem() -> CustomerItem {
        return CustomerItem(id: self.id, name: self.name, email: self.email, phone: self.phone, cityId: self.cityId, stateId: self.stateId, address: self.address, isDeleted: self.isDeleted, iconUrl: self.iconUrl, logoUrl: self.logoUrl, markerColor: self.markerColor)
    }
    
    func update(item: CustomerItem) {
        self.name = item.name
        self.email = item.email
        self.phone = item.phone
        self.cityId = item.cityId
        self.stateId = item.stateId
        self.address = item.address
        self.isDeleted = item.isDeleted ?? false
        self.iconUrl = item.iconUrl
        self.logoUrl = item.logoUrl
        self.markerColor = item.markerColor
    }
}

extension DCustomer {
    static func add(_ customer: CustomerItem) {
        Realm.new?.trySafeWrite({ realm in
            realm.add(DCustomer(item: customer), update: .modified)
        })
    }
    
    static func addAll(_ customers: [CustomerItem]) {
        Realm.new?.trySafeWrite({ realm in
            customers.forEach { customer in
                realm.add(DCustomer(item: customer), update: .modified)
            }
        })
    }
    
    static func update(_ customer: CustomerItem) {
        Realm.new?.trySafeWrite({ realm in
            if let item = realm.object(ofType: DCustomer.self, forPrimaryKey: customer.id) {
                item.update(item: customer)
            }
        })
    }
    
    static var all: Results<DCustomer>? {
        Realm.new?.objects(DCustomer.self)
    }
}

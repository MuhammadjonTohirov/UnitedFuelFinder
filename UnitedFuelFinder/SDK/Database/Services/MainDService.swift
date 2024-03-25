//
//  MainDService.swift
//  USDK
//
//  Created by applebro on 26/10/23.
//

import Foundation
import RealmSwift

actor MainDService {
    public static let shared = MainDService()
    
    public func addState(_ states: [StateItem]) {
        Realm.new?.trySafeWrite({ realm in
            states.map({$0.asObject}).forEach { state in
                realm.add(state, update: .modified)
            }
        })
    }
    
    public func addCity(_ cities: [CityItem]) {
        Realm.new?.trySafeWrite({ realm in
            cities.map({$0.asObject}).forEach { city in
                realm.add(city, update: .modified)
            }
        })
    }
    // deletes and inserts new companies
    public func addCompanies(_ companies: [CompanyItem]) {
        Realm.new?.trySafeWrite({ realm in
            realm.delete(realm.objects(DCompany.self))
            
            companies.map({$0.asObject}).forEach { city in
                realm.add(city, update: .modified)
            }
        })
    }
    
    public func addSearchAddress(_ address: SearchedAddress) {
        Realm.new?.trySafeWrite({ realm in
            realm.add(address.asObject, update: .modified)
        })
    }
    
    public func addStations(_ stations: [StationItem]) {
        Realm.new?.trySafeWrite({ realm in
            realm.add(stations.map({DStationItem.create($0)}), update: .modified)
        })
    }
    
    public func removeAllCustomers() {
        DCustomer.deleteAll()
    }
    
    public func addCustomers(_ customers: [CustomerItem]) {
        DCustomer.addAll(customers)
    }
}

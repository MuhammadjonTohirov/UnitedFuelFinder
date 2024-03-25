//
//  DSearchedItems.swift
//  UnitedFuelFinder
//
//  Created by applebro on 08/11/23.
//

import Foundation
import RealmSwift

public struct SearchedAddress: Objectify {
    var title: String
    var date: Date
    var lat: Double
    var lng: Double
    var address: String
    
    var asObject: Object {
        let obj = DRecentSearchedAddress(title: title, date: date)
        obj.set(lat: lat, lng: lng)
        obj.set(address: address)
        return obj
    }
}

public class DRecentSearchedAddress: Object, Identifiable {
    @Persisted(primaryKey: true) var title: String
    @Persisted var date: Date
    
    @Persisted var address: String = ""
    @Persisted private(set) var lat: Double = 0
    @Persisted private(set) var lng: Double = 0
    
    public init(title: String, date: Date) {
        self.date = date
        super.init()
        self.title = title
    }
    
    public override init() {
        super.init()
    }
    
    func set(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
    
    func set(address: String) {
        self.address = address
    }
}

extension DRecentSearchedAddress {
    static func add(_ item: SearchedAddress) {
        if item.title.replacingOccurrences(of: " ", with: "").isEmpty || item.address.replacingOccurrences(of: " ", with: "").isEmpty {
            return
        }
        
        Realm.new?.trySafeWrite({ realm in
            realm.add(item.asObject, update: .modified)
        })
    }

    //    sorted by inserted date
    static func all() -> Results<DRecentSearchedAddress> {
        Realm.new!.objects(DRecentSearchedAddress.self).sorted(byKeyPath: "date", ascending: false)    
    }
    
    static func deleteAll() {
        Realm.new?.trySafeWrite({ realm in
            realm.delete(realm.objects(DRecentSearchedAddress.self))
        })
    }
}

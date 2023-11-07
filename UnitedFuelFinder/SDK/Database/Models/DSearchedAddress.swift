//
//  DSearchedItems.swift
//  UnitedFuelFinder
//
//  Created by applebro on 08/11/23.
//

import Foundation
import RealmSwift

public struct SearchedAddress: Objectify {
    var id: String
    var title: String
    var lat: Double
    var lng: Double
    
    var asObject: Object {
        DSearchedAddress(id: id, title: title, lat: lat, lng: lng)
    }
}

public class DSearchedAddress: Object, Identifiable {
    @Persisted(primaryKey: true) public var id: String
    @Persisted var title: String
    @Persisted var lat: Double
    @Persisted var lng: Double
    
    public init(id: String = UUID().uuidString, title: String, lat: Double, lng: Double) {
        self.title = title
        self.lat = lat
        self.lng = lng
        super.init()
        self.id = id
    }
    
    public override init() {
        super.init()
    }
}

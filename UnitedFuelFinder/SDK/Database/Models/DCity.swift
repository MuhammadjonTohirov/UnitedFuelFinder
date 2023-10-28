//
//  City.swift
//  USDK
//
//  Created by applebro on 26/10/23.
//

import Foundation
import RealmSwift

public class DCity: Object, Identifiable {
    @Persisted(primaryKey: true) public var id: Int
    @Persisted var name: String
    @Persisted var stateId: String
    @Persisted var lat: Double
    @Persisted var lng: Double
    @Persisted var timezone: String
    
    public init(id: Int, name: String, stateId: String, lat: Double, lng: Double, timezone: String) {
        self.name = name
        self.stateId = stateId
        self.lat = lat
        self.lng = lng
        self.timezone = timezone
        super.init()

        self.id = id
    }
    
    public override init() {
        super.init()
    }
    
    static func allCities(byStateId: String) -> Results<DCity> {
        let cities = Realm.new!.objects(DCity.self).filter("stateId = %@", byStateId)
        return cities
    }
}

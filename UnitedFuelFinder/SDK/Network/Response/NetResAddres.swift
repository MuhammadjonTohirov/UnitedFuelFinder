//
//  NetResAddres.swift
//  USDK
//
//  Created by applebro on 26/10/23.
//

import Foundation

struct NetResState: NetResBody, StateObjectProtocol {
    var id: String
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

struct NetResCity: NetResBody, CityObjectProtocol {
    var id: Int
    var stateId: String?
    var name: String?
    var lat: Double
    var lng: Double
    var timezone: String?
    
    init(id: Int, stateId: String, name: String, lat: Double, lng: Double, timezone: String) {
        self.id = id
        self.stateId = stateId
        self.name = name
        self.lat = lat
        self.lng = lng
        self.timezone = timezone
    }
}

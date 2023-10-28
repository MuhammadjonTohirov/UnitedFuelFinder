//
//  StateObject.swift
//  USDK
//
//  Created by applebro on 26/10/23.
//

import Foundation
import RealmSwift

protocol StateObjectProtocol {
    var id: String {get}
    var name: String {get}
}

protocol CityObjectProtocol {
    var id: Int {get}
    var stateId: String {get}
    var name: String {get}
    var lat: Double {get}
    var lng: Double {get}
    var timezone: String {get}
}

public struct StateItem: StateObjectProtocol, Objectify {
    var id: String
    var name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    init(res: NetResState) {
        self.id = res.id
        self.name = res.name
    }
    
    var asObject: Object {
        DState.init(id: id, name: name)
    }
}

public struct CityItem: CityObjectProtocol, Objectify {
    var id: Int
    var stateId: String
    var name: String
    var lat: Double
    var lng: Double
    var timezone: String
    
    public init(id: Int, stateId: String, name: String, lat: Double, lng: Double, timezone: String) {
        self.id = id
        self.stateId = stateId
        self.name = name
        self.lat = lat
        self.lng = lng
        self.timezone = timezone
    }
    
    init(res: NetResCity) {
        self.id = res.id
        self.stateId = res.stateId
        self.name = res.name
        self.lat = res.lat
        self.lng = res.lng
        self.timezone = res.timezone
    }
    
    var asObject: Object {
        DCity(id: id, name: name, stateId: stateId, lat: lat, lng: lng, timezone: timezone)
    }
}

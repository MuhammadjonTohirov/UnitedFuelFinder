//
//  StationDService.swift
//  UnitedFuelFinder
//
//  Created by applebro on 24/06/24.
//

import Foundation
import RealmSwift

actor StationDService {
    public static let shared = StationDService()
    
    public func allStations()  async -> Results<DStationItem>? {
        guard let realm = await Realm.asyncNew(actor: self) else {
            return nil
        }
        
        return realm.objects(DStationItem.self)
    }
    
    public func addStations(_ stations: [NetResStationItem]) async {
        guard let realm = await Realm.asyncNew(actor: self) else {
            return
        }
        
        realm.add(stations.map({DStationItem.create($0)}))
    }
    
    public func addStations(_ stations: [DStationItem]) async {
        guard let realm = await Realm.asyncNew(actor: self) else {
            return
        }
        
        realm.beginWrite()
        realm.add(stations)
        try? realm.commitWrite()
    }
    
    public func addStation(_ station: NetResStationItem) async {
        guard let realm = await Realm.asyncNew(actor: self) else {
            return
        }
        
        realm.beginWrite()
        realm.add(DStationItem.create(station))
        try? realm.commitWrite()
    }
    
    // delete all
    public func deleteAll() async {
        guard let realm = await Realm.asyncNew(actor: self) else {
            return
        }
        
        realm.beginWrite()
        realm.delete(realm.objects(DStationItem.self))
        try? realm.commitWrite()
    }
}

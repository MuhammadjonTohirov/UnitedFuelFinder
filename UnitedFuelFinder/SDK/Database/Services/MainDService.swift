//
//  MainDService.swift
//  USDK
//
//  Created by applebro on 26/10/23.
//

import Foundation
import RealmSwift

public class MainDService {
    public static let shared = MainDService()
    private(set) lazy var realm: Realm? = {Realm.new}()
//    
//    public func addState(_ states: [StateItem]) {
//        realm?.trySafeWrite({
//            states.map({$0.asObject}).forEach { state in
//                self.realm?.add(state)
//            }
//        })
//    }
//    
//    public func addCity(_ cities: [CityItem]) {
//        realm?.trySafeWrite({
//            cities.map({$0.asObject}).forEach { city in
//                self.realm?.add(city)
//            }
//        })
//    }
}

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
    
    public func addState(_ states: [StateItem]) {
        DataBase.writeThread.async {
            Realm.new?.trySafeWrite({ realm in
                states.map({$0.asObject}).forEach { state in
                    realm.add(state)
                }
            })
        }
    }
    
    public func addCity(_ cities: [CityItem]) {
        DataBase.writeThread.async {
            Realm.new?.trySafeWrite({ realm in
                cities.map({$0.asObject}).forEach { city in
                    realm.add(city)
                }
            })
        }
    }
    
    public func addCompanies(_ companies: [CompanyItem]) {
        DataBase.writeThread.async {
            Realm.new?.trySafeWrite({ realm in
                companies.map({$0.asObject}).forEach { city in
                    realm.add(city)
                }
            })
        }
    }
}

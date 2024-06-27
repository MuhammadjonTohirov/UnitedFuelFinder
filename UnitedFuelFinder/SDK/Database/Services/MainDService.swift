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
    
    public func addState(_ states: [StateItem]) async {
        guard let realm = await Realm.asyncNew(actor: self) else {
            return
        }
        
        realm.beginWrite()
        states.map({$0.asObject}).forEach { state in
            realm.add(state, update: .modified)
        }
        try? realm.commitWrite()
    }
    
    public func addCity(_ cities: [CityItem]) async {
        guard let realm = await Realm.asyncNew(actor: self) else {
            return
        }
        
        realm.beginWrite()
        cities.map({$0.asObject}).forEach { city in
            realm.add(city, update: .modified)
        }
        try? realm.commitWrite()
    }
    // deletes and inserts new companies
    public func addCompanies(_ companies: [CompanyItem]) async {
        guard let realm = await Realm.asyncNew(actor: self) else {
            return
        }
        
        realm.beginWrite()
        companies.map({$0.asObject}).forEach { company in
            realm.add(company, update: .modified)
        }
        try? realm.commitWrite()
    }
    
    public func addSearchAddress(_ address: SearchedAddress) async {
        guard let realm = await Realm.asyncNew(actor: self) else {
            return
        }
        
        realm.beginWrite()
        realm.add(address.asObject, update: .modified)
        try? realm.commitWrite()
    }
    
    public func removeAllCustomers() async {
        guard let realm = await Realm.asyncNew(actor: self) else {
            return
        }
        
        realm.beginWrite()
        realm.delete(realm.objects(DCustomer.self))
        try? realm.commitWrite()
    }
    
    public func addCustomers(_ customers: [CustomerItem]) async {
        guard let realm = await Realm.asyncNew(actor: self) else {
            return
        }
        
        realm.beginWrite()
        customers.forEach { customer in
            realm.add(DCustomer(item: customer), update: .modified)
        }
        try? realm.commitWrite()
    }
}

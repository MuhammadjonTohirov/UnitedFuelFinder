//
//  DCompany.swift
//  UnitedFuelFinder
//
//  Created by applebro on 02/11/23.
//

import Foundation
import RealmSwift

public class DCompany: Object, Identifiable {
    @Persisted(primaryKey: true) public var id: Int
    @Persisted var name: String
    @Persisted var email: String
    @Persisted var phone: String
    @Persisted var cityId: Int
    @Persisted var stateId: String
    @Persisted var address: String
    @Persisted var isDeleted: Bool
    @Persisted var logoUrl: String?
    
    public init(id: Int, name: String, email: String, phone: String, cityId: Int, stateId: String, address: String, isDeleted: Bool, logoUrl: String? = nil) {
        self.name = name
        self.email = email
        self.phone = phone
        self.cityId = cityId
        self.stateId = stateId
        self.address = address
        self.isDeleted = isDeleted
        self.logoUrl = logoUrl
        super.init()
        self.id = id
    }
    
    public init(item: CompanyItem) {
        self.name = item.name
        self.email = item.email
        self.phone = item.phone
        self.cityId = item.cityId
        self.stateId = item.stateId ?? ""
        self.address = item.address
        self.isDeleted = item.isDeleted
        self.logoUrl = item.logoUrl
        super.init()
        self.id = item.id
    }
    
    public override init() {
        super.init()
    }
    
    static func allCompanies() -> Results<DCompany> {
        return Realm.new!.objects(DCompany.self)
    }
}

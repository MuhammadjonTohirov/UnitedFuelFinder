//
//  UserInfo.swift
//  UnitedFuelFinder
//
//  Created by applebro on 30/10/23.
//

import Foundation

public struct UserInfo: Codable, Hashable {
    let id: String?
    
    var fullName: String {
        return "\(firstName ?? "") \(lastName ?? "")"
    }
    
    var firstName: String?
    var lastName: String?
    
    let email: String
    var phone: String
    let cardNumber: String
    let companyId: Int?
    let companyName: String?
    var address: String?
    var cityId: Int?
    var cityName: String?
    let state: String?
    var stateId: String?
    var stateName: String?
    let confirmed: Bool?
    let deleted: Bool?
    var permissionList: [String]?
    let registerTime: String?
    let driverUnit: String?
    let accountId: Int?
    let accountName: String?
    var efsAccountId: Int?
    var efsAccountName: String?
    var includeStations: [String]?
    var roleCode: String
    var organizationId: Int?
    var organizationName: String?
    
    var registerTimeBeautified: String {
        // mm/dd/YYYY HH:mm:ss
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        let date = formatter.date(from: registerTime ?? "")
        return formatter.string(from: date ?? Date())
    }

    var canViewInvoices: Bool {
        permissionList?.contains("view_invoices") ?? false
    }
    
    var canViewTransactions: Bool {
        permissionList?.contains("view_transactions") ?? false
    }
    
    var showDiscountPrices: Bool {
        permissionList?.contains("shown_discount_prices") ?? false
    }
    
    var showDiscountedPrices: Bool {
        permissionList?.contains("shown_discounted_prices") ?? false
    }
    
//   create init, and set default nil if property is optional
    public init(id: String? = nil, firstName: String? = nil, lastName: String? = nil, email: String, phone: String, cardNumber: String, companyId: Int? = nil, companyName: String? = nil, address: String? = nil, cityId: Int? = nil, cityName: String? = nil, state: String? = nil, stateId: String? = nil, stateName: String? = nil, confirmed: Bool? = nil, deleted: Bool? = nil, permissionList: [String]? = nil, registerTime: String? = nil, driverUnit: String? = nil, accountId: Int? = nil, accountName: String? = nil, role: String = "driver", stations: [String]) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.cardNumber = cardNumber
        self.companyId = companyId
        self.companyName = companyName
        self.address = address
        self.cityId = cityId
        self.cityName = cityName
        self.state = state
        self.stateId = stateId
        self.stateName = stateName
        self.confirmed = confirmed
        self.deleted = deleted
        self.permissionList = permissionList
        self.registerTime = registerTime
        self.driverUnit = driverUnit
        self.accountId = accountId
        self.includeStations = stations
        self.accountName = accountName
        self.roleCode = role
    }
    
    init(res: NetResUserInfo) {
        self.id = res.id
        self.firstName = res.firstName
        self.lastName = res.lastName
        self.email = res.email ?? ""
        self.phone = res.phone ?? ""
        self.cardNumber = res.cardNumber ?? ""
        self.companyId = res.companyId
        self.companyName = res.companyName
        self.address = res.address
        self.cityId = res.cityId
        self.cityName = res.cityName
        self.state = res.state
        self.stateId = res.stateId
        self.stateName = res.stateName
        self.confirmed = res.confirmed
        self.deleted = res.deleted
        self.permissionList = res.permissionList
        self.registerTime = res.registerTime
        self.driverUnit = res.driverUnit
        self.accountId = res.accountId
        self.accountName = res.accountName
        self.roleCode = res.roleCode ?? ""
        self.efsAccountId = res.efsAccountId
        self.efsAccountName = res.efsAccountName
        self.includeStations = res.includeStations
        self.organizationId = res.organizationId
        self.organizationName = res.organizationName
    }
    
    var permissionsString: String {
        (
            self.permissionList?.map {
                $0.localize
            }
        )?.joined(separator: ", ") ?? "no.access".localize
    }
    
    var stations: [CustomerItem] {
        self.includeStations?.compactMap {
            customer(id: $0)
        } ?? []
    }
    
    var stationNamesString: String {
        isAllStationsSelected ? "all".localize :
        stations.map {$0.name} .joined(separator: ", ")
    }
    
    var hasAnyPermission: Bool {
        self.permissionList?.isEmpty ?? false
    }
    
    var isAllStationsSelected: Bool {
        (DCustomer.all?.count ?? 0) <= (self.includeStations?.count ?? 0)
    }
    
    func customer(id: String) -> CustomerItem? {
        DCustomer.all?.filter("id = %@", Int(id) ?? 0).first?.asModel
    }
    
    var userType: UserType {
        self.roleCode == "company" ? .company : .driver
    }
}

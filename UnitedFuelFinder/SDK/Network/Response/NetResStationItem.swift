//
//  NetResStationItem.swift
//  UnitedFuelFinder
//
//  Created by applebro on 29/10/23.
//

import Foundation

struct NetResStationItem: NetResBody {
    var id: Int
    var name: String
    var lat: Double
    var lng: Double
    var isDeleted: Bool?
    var cityId: Int?
    var cityName: String?
    var customerId: Int
    var address: String?
    var phone: String?
    var stateId: String?
    var stateName: String?
    var discountPrice: Float?
    var priceUpdated: String
    var retailPrice: Float?
    var number: String?
    var logoUrl: String?
    var note: String?
    var distance: Float?
    var identifier: String?
    var isEmpty: Bool?
    var isOpen: Bool?
    var bestPrice: Float?
    var customerName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case lat
        case lng
        case isDeleted
        case cityId
        case customerId
        case address
        case phone
        case stateId
        case discountPrice
        case priceUpdated
        case retailPrice
        case number
        case note
        case logoUrl = "logoUrl"
        case distance
        case cityName
        case stateName
        
        case identifier
        case isEmpty
        case isOpen
        case bestPrice
        case customerName
    }
    
    init(id: Int, name: String, lat: Double, lng: Double, isDeleted: Bool? = nil, cityId: Int? = nil, cityName: String? = nil, customerId: Int, address: String? = nil, phone: String? = nil, stateId: String? = nil, stateName: String? = nil, discountPrice: Float? = nil, priceUpdated: String, retailPrice: Float? = nil, number: String? = nil, logoUrl: String? = nil, note: String? = nil, distance: Float? = nil) {
        self.id = id
        self.name = name
        self.lat = lat
        self.lng = lng
        self.isDeleted = isDeleted
        self.cityId = cityId
        self.cityName = cityName
        self.customerId = customerId
        self.address = address
        self.phone = phone
        self.stateId = stateId
        self.stateName = stateName
        self.discountPrice = discountPrice
        self.priceUpdated = priceUpdated
        self.retailPrice = retailPrice
        self.number = number
        self.logoUrl = logoUrl
        self.note = note
        self.distance = distance
        self.identifier = nil
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        lat = try container.decode(Double.self, forKey: .lat)
        lng = try container.decode(Double.self, forKey: .lng)
        isDeleted = try? container.decodeIfPresent(Bool.self, forKey: .isDeleted)
        cityId = try? container.decodeIfPresent(Int.self, forKey: .cityId)
        customerId = try container.decode(Int.self, forKey: .customerId)
        address = try? container.decodeIfPresent(String.self, forKey: .address)
        phone = try? container.decodeIfPresent(String.self, forKey: .phone)
        stateId = try? container.decodeIfPresent(String.self, forKey: .stateId)
        stateName = try? container.decodeIfPresent(String.self, forKey: .stateName)
        discountPrice = try? container.decodeIfPresent(Float.self, forKey: .discountPrice)
        priceUpdated = try container.decode(String.self, forKey: .priceUpdated)
        retailPrice = try? container.decodeIfPresent(Float.self, forKey: .retailPrice)
        number = try? container.decodeIfPresent(String.self, forKey: .number)
        logoUrl = try? container.decodeIfPresent(String.self, forKey: .logoUrl)
        note = try? container.decodeIfPresent(String.self, forKey: .note)
        distance = try? container.decodeIfPresent(Float.self, forKey: .distance)
        identifier = try? container.decodeIfPresent(String.self, forKey: .identifier)
        isEmpty = try? container.decodeIfPresent(Bool.self, forKey: .isEmpty)
        isOpen = try? container.decodeIfPresent(Bool.self, forKey: .isOpen)
        bestPrice = try? container.decodeIfPresent(Float.self, forKey: .bestPrice)
        customerName = try? container.decodeIfPresent(String.self, forKey: .customerName)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(lat, forKey: .lat)
        try container.encode(lng, forKey: .lng)
        try container.encodeIfPresent(isDeleted, forKey: .isDeleted)
        try container.encodeIfPresent(cityId, forKey: .cityId)
        try container.encode(customerId, forKey: .customerId)
        try container.encodeIfPresent(address, forKey: .address)
        try container.encodeIfPresent(phone, forKey: .phone)
        try container.encodeIfPresent(stateId, forKey: .stateId)
        try container.encodeIfPresent(stateName, forKey: .stateName)
        try container.encodeIfPresent(discountPrice, forKey: .discountPrice)
        try container.encode(priceUpdated, forKey: .priceUpdated)
        try container.encodeIfPresent(retailPrice, forKey: .retailPrice)
        try container.encodeIfPresent(number, forKey: .number)
        try container.encodeIfPresent(logoUrl, forKey: .logoUrl)
        try container.encodeIfPresent(note, forKey: .note)
        try container.encodeIfPresent(distance, forKey: .distance)
        try container.encodeIfPresent(identifier, forKey: .identifier)
        try container.encodeIfPresent(isEmpty, forKey: .isEmpty)
        try container.encodeIfPresent(isOpen, forKey: .isOpen)
        try container.encodeIfPresent(bestPrice, forKey: .bestPrice)
        try container.encodeIfPresent(customerName, forKey: .customerName)
    }
}

//
//  NetResSearchAddress.swift
//  UnitedFuelFinder
//
//  Created by applebro on 22/12/23.
//

import Foundation
import CoreLocation

struct NetResSearchAddressItem: Codable {
    var address: NetResSearchAddressItemAddress?
    var coords: NetResSearchAddressItemCoords?
    var region: Int?
    var poiTypeID: Int?
    var persistentPOIID: Int?
    var siteID: Int?
    var resultType: Int?
    var shortString: String?
    var timeZone: String?
}

struct NetResSearchAddressItemAddress: Codable {
    var streetAddress: String
    var localArea: String?
    var city: String?
    var state: String?
    var stateName: String?
    var zip: String?
    var county: String?
    var country: String?
    var countryFullName: String?
    var splc: String?
}

struct NetResSearchAddressItemCoords: Codable {
    var lat: Double
    var lon: Double
    
    var asLocation: CLLocation {
        .init(latitude: lat, longitude: lon)
    }
}

extension NetResSearchAddressItem {
    
    var addressString: String {
        var _str = address?.streetAddress ?? ""
        _str.removeAll(where: {$0 == " "})
        
        let addressList: [String?] = [
            _str.nilIfEmpty,
            address?.city?.nilIfEmpty,
            address?.state?.nilIfEmpty,
            address?.zip?.nilIfEmpty
        ]
        
        return addressList.compactMap { $0 }.joined(separator: ", ")
    }
}

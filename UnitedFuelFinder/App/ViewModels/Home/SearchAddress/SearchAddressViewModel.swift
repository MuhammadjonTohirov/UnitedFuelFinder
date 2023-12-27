//
//  SearchAddressViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 07/11/23.
//

import Foundation
import Combine
import SwiftUI
import CoreLocation

struct SearchAddressItem: Identifiable {
    enum SType {
        case address
        case history
    }
    
    var id: String {
        title
    }
    
    var title: String
    var type: SearchAddressItem.SType
    var coordinate: CLLocation?
    
    var icon: Image {
        switch type {
        case .address:
            Image(systemName: "mappin")
        case .history:
            Image(systemName: "clock")
        }
    }
}

extension SearchAddressItem {
    init(res: NetResSearchAddressItem) {
        self.title = res.addressString
        self.type = .address
        self.coordinate = res.coords?.asLocation
    }
    
    var distanceString: String {
        guard let cloc = GLocationManager.shared.currentLocation else {
            return ""
        }
        
        guard let coord = coordinate else {
            return ""
        }
        
        let distance = cloc.distance(from: coord)
        
        return distance < 1000 ? "\(Int(distance)) m" : "\(String(format: "%.2f", distance/1000)) km"
    }
}

final class SearchAddressViewModel: ObservableObject {
    
    struct SearchAddressResult {
        var address: String
        var lat: Double
        let lng: Double
    }
    
    @Published public var addressList: [SearchAddressItem] = []
    @Published public var addressText: String = ""
    @Published public var addressValue: String = ""
    @Published public var isLoading: Bool = false
    
    private var searchCancellables = Set<AnyCancellable>()

    func onAppear() {
        $addressText
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main, options: nil)
            .sink(receiveValue: { [weak self] val in
                self?.searchPlaces(val)
            })
            .store(in: &searchCancellables)
        
        if !addressText.isEmpty {
            searchPlaces(addressText)
        } else {
            fetchRecentAddresses()
        }
    }
    
    private func searchPlaces(_ text: String) {
        if text.isEmpty {
            return
        }
        
        isLoading = true
        
        Task {
            let _addresses = await MainService.shared.searchAddresses(text)
            
            await MainActor.run {
                isLoading = false
                self.addressList = _addresses.map { addr in
                    SearchAddressItem(res: addr)
                }
            }
        }
    }
    
    private func fetchRecentAddresses() {
        let recentItems = DRecentSearchedAddress.all()
        addressList = recentItems.map { .init(title: $0.title, type: .history) }
    }
    
    func onClickAddress(_ address: SearchAddressItem, completion: @escaping (SearchAddressResult?) -> Void) {
        if address.type == .history {
            self.addressText = address.title
        }
        
        self.isLoading = true
        
        let _coor = address.coordinate?.coordinate ?? .init(latitude: 0, longitude: 0)
        let _addr = DRecentSearchedAddress(title: self.addressText, date: Date())
        _addr.set(lat: _coor.latitude, lng: _coor.longitude)
        _addr.set(address: address.title)
        
        DRecentSearchedAddress.add(.init(title: self.addressText, date: Date()))
        
        completion(.init(address: address.title, lat: _coor.latitude, lng: _coor.longitude))
    }
}

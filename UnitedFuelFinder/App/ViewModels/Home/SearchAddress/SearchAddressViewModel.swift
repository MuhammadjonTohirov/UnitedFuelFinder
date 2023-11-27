//
//  SearchAddressViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 07/11/23.
//

import Foundation
import Combine
import SwiftUI

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
    
    var icon: Image {
        switch type {
        case .address:
            Image(systemName: "mappin")
        case .history:
            Image(systemName: "clock")
        }
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
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main, options: nil)
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
        GLocationManager.shared.fetchPlaces(forInput: text) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let success):
                    self.addressList = success.map({.init(title: $0, type: .address)})
                    
                case .failure:
                    break
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
            self.onClickAddress(.init(title: address.title, type: .address), completion: completion)
            return
        }
        
        self.isLoading = true
        GLocationManager.shared.getCoordinates(forAddress: address.title) { [weak self] result in
            guard let self else {
                return
            }
            
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let success):
                    DRecentSearchedAddress.add(.init(title: self.addressText, date: Date()))
                    completion(.init(address: address.title, lat: success.latitude, lng: success.longitude))
                case .failure:
                    completion(nil)
                }
            }
        }
    }
}

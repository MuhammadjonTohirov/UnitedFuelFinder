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
    var address: String?
    
    var icon: Icon {
        switch type {
        case .address:
            Icon(systemName: "mappin")
        case .history:
            Icon(systemName: "clock")
        }
    }
}

extension SearchAddressItem {
    init(res: NetResSearchAddressItem) {
        self.title = res.addressString
        self.address = res.addressString
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

protocol SearchAddressProtocol: AnyObject {
    func searchAddress(viewModel: SearchAddressViewModel, result: SearchAddressViewModel.SearchAddressResult)
    
    func searchAddress(viewModel: SearchAddressViewModel, edit: SearchAddressViewModel.SearchAddressResult?)
    
    func searchAddress(viewModel: SearchAddressViewModel, onCancel: SearchAddressViewModel.SearchAddressResult?)
}

final class SearchAddressViewModel: ObservableObject {
    struct SearchAddressResult {
        var id: String?
        var address: String
        var lat: Double
        let lng: Double
        
        init(id: String? = nil, address: String, lat: Double, lng: Double) {
            self.id = id
            self.address = address
            self.lat = lat
            self.lng = lng
        }
    }
    private(set) var input: MapDestination?
    
    @Published public var addressHistoryList: [SearchAddressItem] = []
    @Published public var addressList: [SearchAddressItem] = []
    @Published public var addressText: String = ""
    @Published public var addressValue: String = ""
    @Published public var isLoading: Bool = false
    
    weak var delegate: SearchAddressProtocol?
    
    private var searchCancellables = Set<AnyCancellable>()

    private var didAppear: Bool = false
    
    func onAppear() {
        if didAppear {
            return
        }
        
        didAppear = true
        $addressText
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main, options: nil)
            .sink(receiveValue: { [weak self] val in
                self?.searchPlaces(val)
            })
            .store(in: &searchCancellables)
        
        if let input, let address = input.address?.nilIfEmpty {
            addressText = address
            searchPlaces(address.prefix(6).description)
        } else {
            fetchRecentAddresses()
        }
    }
    
    func dispose() {
        isLoading = false
        addressList = []
        addressText = ""
        didAppear = false
        searchCancellables.removeAll()
    }
    
    func set(input: MapDestination?) {
        self.input = input
//        self.addressText = input?.address ?? ""
    }
    
    private func searchPlaces(_ text: String) {
        if text.isEmpty {
            self.addressList = []
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
        addressHistoryList = recentItems.map { .init(title: $0.title, type: .history, coordinate: .init(latitude: $0.lat, longitude: $0.lng), address: $0.address) }
    }
    
    func onClickMap() {
        var editingObj: SearchAddressResult?
        
        if let input {
            editingObj = SearchAddressResult.init(
                id: input.id,
                address: input.address ?? "",
                lat: input.location.latitude,
                lng: input.location.longitude
            )
        }
        
        delegate?.searchAddress(viewModel: self, edit: editingObj)
    }
    
    func onClickAddress(_ address: SearchAddressItem) {
        if address.type == .history {
            self.addressText = (address.address ?? "").nilIfEmpty ?? address.title
        }
        
        self.isLoading = true
        
        let _coor = address.coordinate?.coordinate ?? .init(latitude: 0, longitude: 0)
        
        DRecentSearchedAddress.add(.init(
            title: self.addressText,
            date: Date(), 
            lat: _coor.latitude, lng: _coor.longitude,
            address: address.address ?? address.title
        ))
        
        delegate?.searchAddress(
            viewModel: self,
            result: .init(
                id: input?.id ?? nil,
                address: address.address?.nilIfEmpty ?? address.title,
                lat: _coor.latitude,
                lng: _coor.longitude
            )
        )
    }
    
    func onClickCancel() {
        self.delegate?.searchAddress(viewModel: self, onCancel: nil)
    }
}

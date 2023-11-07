//
//  SearchAddressViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 07/11/23.
//

import Foundation
import Combine

final class SearchAddressViewModel: ObservableObject {
    
    struct SearchAddressResult {
        var address: String
        var lat: Double
        let lng: Double
    }
    
    @Published public var addressList: [String] = []
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
    }
    
    
    private func searchPlaces(_ text: String) {
        isLoading = true
        GLocationManager.shared.fetchPlaces(forInput: text) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let success):
                    self.addressList = success
                    
                case .failure:
                    break
                }
            }
        }
    }
    
    func onClickAddress(_ address: String, completion: @escaping (SearchAddressResult?) -> Void) {
        self.isLoading = true
        GLocationManager.shared.getCoordinates(forAddress: address) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let success):
                    completion(.init(address: address, lat: success.latitude, lng: success.longitude))
                case .failure:
                    completion(nil)
                }
            }
        }
    }
}

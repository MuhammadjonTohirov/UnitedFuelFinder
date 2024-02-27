//
//  DashboardViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/02/24.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

enum DashboardRoute: ScreenRoute {
    var id: String {
        switch self {
        case .transferringStations:
            return "transferringStations"
        case .notifications:
            return "notifications"
        case .invoices:
            return "invoices"
        case .profile:
            return "profile"
        }
    }
    
    case transferringStations
    case invoices
    case notifications
    case profile
    @ViewBuilder
    var screen: some View {
        switch self {
        case .transferringStations:
            AllTransactionsView()
        case .notifications:
            NotificationsView()
        case .invoices:
            AllInvoicesView()
        case .profile:
            ProfileVIew()
        }
    }
}

protocol DashboardViewModelProtocol: ObservableObject {
    func setCurrentLocation(_ location: CLLocation?)
    func setDiscounted(stations: [StationItem])
    func navigate(to page: DashboardRoute)
}

class DashboardViewModel: ObservableObject, DashboardViewModelProtocol {
    @Published var push: Bool = false
    private(set) var interactor: (any DashboardInteractorProtocol)
    @Published var transactions: [TransactionItem] = []
    @Published var invoices: [InvoiceItem] = []
    @Published var discountedStations: [StationItem] = []
    @Published var isLoading: Bool = false
    @Published var currentLocation: CLLocation?
    private var didAppear: Bool = false
    
    init(interactor: any DashboardInteractorProtocol = DashboardInteractor()) {
        self.interactor = interactor
    }
    
    var route: DashboardRoute? {
        didSet {
            push = route != nil
        }
    }
    
    func onAppear() {
        if didAppear {
            return
        }
        
        didAppear = true
        
        reloadData()
    }
    
    func navigate(to page: DashboardRoute) {
        self.route = page
    }
    
    func reloadData() {
        Task {
            startLoading()
            await loadTransactions()
            await loadInvoices()
            stopLoading()
        }
    }
    
    func setCurrentLocation(_ location: CLLocation?) {
        self.currentLocation = location
    }
    
    func setDiscounted(stations: [StationItem]) {
        self.discountedStations = stations
    }
    
    func openStation(_ stationItem: StationItem) {
        GLocationManager.shared.openLocationOnMap(stationItem.coordinate, name: stationItem.name)
    }
}

extension DashboardViewModel {
    func startLoading() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
}

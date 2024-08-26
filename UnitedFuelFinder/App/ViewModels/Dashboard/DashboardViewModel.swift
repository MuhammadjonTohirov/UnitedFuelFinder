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
    static func == (lhs: DashboardRoute, rhs: DashboardRoute) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
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
        case .stationInfo:
            return "station"
        case .cards:
            return "cards"
        }
    }
    
    case transferringStations
    case invoices
    case notifications
    case profile
    case stationInfo(_ station: StationItem)
    case cards
    
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
        case .stationInfo(let sta):
            StationDetailsView(station: sta)
        case .cards:
            AllCardsView()
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
    
    @Published var sepndingsViewModel: TotalSpendingsViewModel = .init()
    
    @Published var transactions: [TransactionItem] = []
    @Published var invoices: [InvoiceItem] = []
    @Published var discountedStations: [StationItem] = []
    
    @Published var isLoading: Bool = false
    @Published var currentLocation: CLLocation?
    
    @Published var chartData:[PieSlice] = []
    
    private var didAppear: Bool = false
    
    init(interactor: any DashboardInteractorProtocol = DashboardInteractor()) {
        self.interactor = interactor
        self.chartData = [
        ]
    }
    
    var route: DashboardRoute? {
        didSet {
            self.push = self.route != nil
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
        DispatchQueue.main.async {
            self.route = page
        }
    }
    
    func reloadData() {
        Task {
            startLoading()
            await loadTransactions()
            await loadInvoices()
            await loadVersion()
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

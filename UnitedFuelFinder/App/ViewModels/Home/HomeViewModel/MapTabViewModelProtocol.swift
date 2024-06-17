//
//  MapTabViewModelProtocol.swift
//  UnitedFuelFinder
//
//  Created by applebro on 05/06/24.
//

import Foundation
import GoogleMaps

enum HomeViewState {
    case `default`
    case pickLocation
    case routing
}

enum HomeBodyState: Int {
    case map = 0
    case list
}

protocol MapTabViewModelProtocl: ObservableObject {
    var route: MapTabRouter? {get set}
    var filter: MapFilterInput? {get}
    var isFilteringStations: Bool {get set}
    var isLoading: Bool {get set}
    var isDragging: Bool {get set}
    var state: HomeViewState {get set}
    var filterUrlSession: URLSession {get}
    var focusableLocation: CLLocation? {get set}
    var delegate: MapTabViewModelDelegate? {get set}
    
    var fromAddress: String {get}
    var toAddress: String {get}
        
    var presentableRoute: HomePresentableSheets? {get set}
    
    var push: Bool {get set}
    
    var present: Bool {get set}
    
    var pickedLocation: CLLocation? {get set}
    var pickedLocationAddress: String? {get set}

    var isDrawing: Bool {get set}
    var isDetectingAddressFrom: Bool {get set}
    var isDetectingAddressTo: Bool {get set}
    
    var loadingMessage: String {get}
        
    var hasDrawen: Bool {get}
    var fromLocation: MapDestination? {get}
    var toLocation: MapDestination? {get}
    
    var stations: [StationItem] {get set}
    
    var stationsMarkers: Set<GMSMarker> {get set}
    
    var distance: String {get}
    
    func set(currentLocation location: CLLocation?)
    func set(filter: MapFilterInput)
    
    func startFilterStations()
    func onAppear()
    
    func onClickpickLocationPointOnMap()
    func onClickSettings()
    func onClickNotification()
    func onClickViewAllStations()
    func onClickBack()
    func onClickSearchAddressFrom()
    func onClickSearchAddressTo()
    func onClickFromLocation()
    func onClickToLocation()
    func reloadAddress()
    func onEndDrawingRoute(_ isOK: Bool)
    func focusToLocation(_ location: CLLocationCoordinate2D)
    func focusToCurrentLocation()
    func clearDestination()
    func onClickDonePickAddress()
    func onClickAllDestinations()
    func onClickAddDestination()
}

extension MapTabViewModelProtocl {
    var filterUrlSession: URLSession {
        .filter
    }
    
    func onClickpickLocationPointOnMap() {}
    func onClickSettings() {}
    func onClickNotification() {}
    func onClickViewAllStations() {}
    func onClickBack() {}
    func onClickSearchAddressFrom() {}
    func onClickSearchAddressTo() {}
    func onClickFromLocation() {}
    func onClickToLocation() {}
}

//
//  MapTabListView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 21/02/24.
//

import Foundation
import SwiftUI
import CoreLocation

struct MapTabListView: View {
    var stations: [StationItem]
    var fromPoint: CLLocationCoordinate2D?
    @EnvironmentObject var mapModel: MapTabViewModel
    
    private var isLoading: Bool {
        mapModel.isFilteringStations || mapModel.isLoading
    }
    
    private var centerMessage: String {
        isLoading ? "loading".localize : "no.stations".localize
    }
    
    var body: some View {
        ZStack {
            ForEach(stations) { station in
                GasStationItemView(station: station, fromPoint: fromPoint)
                    .set(navigate: { stationItem in
                        GLocationManager.shared.openLocationOnMap(stationItem.coordinate, name: stationItem.name)
                    })
                    .padding(.horizontal, Padding.default)
                    .padding(.vertical, Padding.small)
                    .onTapGesture {
                        mapModel.route = .stationDetails(station: station)
                    }
                    
            }
            .scrollable(axis: .vertical)
            
            Text(centerMessage)
                .font(.system(size: 32, weight: .bold))
                .opacity(0.5)
                .opacity(stations.isEmpty ? 1 : 0 )
            
            ProgressView()
                .set(isVisible: isLoading)
                .padding(.bottom, 100)
        }
    }
}

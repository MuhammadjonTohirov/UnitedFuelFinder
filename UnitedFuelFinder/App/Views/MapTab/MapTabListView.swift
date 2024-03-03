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
    var body: some View {
        ZStack {
            ForEach(stations) { station in
                GasStationItemView(station: station, fromPoint: fromPoint)
                    .set(navigate: { stationItem in
                        GLocationManager.shared.openLocationOnMap(stationItem.coordinate, name: stationItem.name)
                    })
                    .padding(.horizontal, Padding.default)
                    .padding(.vertical, Padding.small)
            }
            .scrollable(axis: .vertical)
            
            Text("no.stations".localize)
                .font(.system(size: 32, weight: .bold))
                .opacity(0.5)
                .opacity(stations.isEmpty ? 1 : 0 )
        }
    }
}

#Preview {
    MapTabListView(stations: [])
}

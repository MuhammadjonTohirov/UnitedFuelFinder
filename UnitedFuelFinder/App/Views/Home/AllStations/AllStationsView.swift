//
//  AllStationsView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 30/10/23.
//

import Foundation
import SwiftUI

struct AllStationsView: View {
    var from: String?
    var to: String?
    var radius: String?
    var stations: [StationItem]
    
    var filteredStations: [StationItem] {
        stations.filter({$0.name.lowercased().starts(with: searchText.lowercased())})
    }
    
    @State private var searchText = ""
    var body: some View {
        VStack {
            AnyView(headlineView)
                .padding(.horizontal, Padding.medium)
                .padding(.vertical, Padding.small)
            
            if !filteredStations.isEmpty {
                LazyVStack {
                    ForEach(filteredStations) { st in
                        GasStationItemView(station: st)
                    }
                }
                .padding(.horizontal, Padding.medium)
                .scrollable(axis: .vertical)
            } else {
                Text("no_item_found".localize)
                    .padding(.top, Padding.default)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.init(uiColor: .secondaryLabel))
                Spacer()
            }
        }
        .navigationTitle("all_stations".localize)
        .searchable(text: $searchText)
    }
    
    var headlineView: any View {
        guard let from, let to else {
            if let radius {
                return HStack {
                    Text("stations_at_radius".localize(arguments: radius))
                        .foregroundStyle(Color.init(uiColor: .secondaryLabel))
                        .font(.system(size: 13, weight: .regular))
                    Spacer()
                }
            }
            
            return EmptyView()
        }
        
        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("from".localize + ": ")
                    .frame(width: 42)
                    .foregroundStyle(Color.init(uiColor: .secondaryLabel))
                
                Text(from)
            }
            
            HStack {
                Text("to".localize + ": ")
                    .frame(width: 42)
                    .foregroundStyle(Color.init(uiColor: .secondaryLabel))
                
                Text(to)
            }
        }
        .font(.system(size: 13, weight: .regular))
    }
}

#Preview {
    @State var stations: [StationItem] = []
    return AllStationsView(from: nil, to: nil, radius: "25 km", stations: stations)
    .onAppear {
        Task {
            let sts = await MainService.shared.findStations(atCity: "1")
            
            DispatchQueue.main.async {
                stations = sts
            }
        }
    }
}

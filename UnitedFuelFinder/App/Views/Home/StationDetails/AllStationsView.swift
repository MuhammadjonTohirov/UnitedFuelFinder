//
//  AllStationsView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 30/10/23.
//

import Foundation
import SwiftUI
import MapKit
struct AllStationsView: View {
    var from: String?
    var to: String?
    var location: CLLocationCoordinate2D?
    var radius: Int?
    
    var onClickNavigate: ((StationItem) -> Void)?
    var onClickOpen: ((StationItem) -> Void)?
    
    @State var stations: [StationItem]
    @Environment(\.presentationMode) var presentationMode
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
                            .set(navigate: { station in
                                presentationMode.wrappedValue.dismiss()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                    self.onClickNavigate?(station)
                                }
                            })
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                    self.onClickOpen?(st)
                                }
                            }
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
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("cancel".localize.capitalized)
                        .foregroundStyle(Color.label)
                        .font(.system(size: 14, weight: .semibold))
                })
            }
        })
        .onAppear {
//            Task {
//                guard let loc = location, let rad = radius else {
//                    return
//                }
//                
//                let _stations = await MainService.shared.discountedStations(atLocation: (loc.latitude, loc.longitude), in: rad, limit: 1000)
//                    .sorted(by: {$0.trustedDiscountPrice > $1.trustedDiscountPrice})
//                
//                await MainActor.run {
//                    self.stations = _stations
//                }
//            }
        }
    }
    
    var headlineView: any View {
        guard let from, let to else {
            if let radius {
                return HStack {
                    Text("stations_at_radius".localize(arguments: "\(radius) mi"))
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
    return AllStationsView(from: nil, to: nil, radius: 25, stations: stations)
    .onAppear {
        Task {
            let sts = await MainService.shared.findStations(atCity: "1")
            
            DispatchQueue.main.async {
                stations = sts
            }
        }
    }
}

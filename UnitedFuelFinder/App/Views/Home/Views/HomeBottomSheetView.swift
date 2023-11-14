//
//  HomeBottomSheetView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 18/10/23.
//

import Foundation
import SwiftUI

struct HomeBottomSheetView: View {
    var input: HomeBottomSheetInput
    var stations: [StationItem] = []
    var hasMoreButton: Bool
    private var isSearching: Bool = false
    private var onClickMoreButton: (() -> Void)? = nil
    private var onClickNavigate: ((StationItem) -> Void)? = nil
    private var onClickOpen: ((StationItem) -> Void)? = nil
    private var stationItemHeight: CGFloat = 110
    
    init(input: HomeBottomSheetInput, stations: [StationItem], hasMoreButton: Bool, isSearching: Bool = false,
         onClickMoreButton: (() -> Void)? = nil,
         onClickNavigate: ((StationItem) -> Void)? = nil,
         onClickOpen: ((StationItem) -> Void)? = nil
    ) {
        self.input = input
        self.stations = stations
        self.hasMoreButton = hasMoreButton
        self.onClickMoreButton = onClickMoreButton
        self.onClickNavigate = onClickNavigate
        self.onClickOpen = onClickOpen
        self.isSearching = isSearching
    }
    
    var body: some View {
        innerBody
            .padding(Padding.medium)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.background)
                    .ignoresSafeArea()
                    .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 0)
            }
    }
    
    @ViewBuilder
    private var innerBody: some View {
        switch input.state {
        case .mainView:
            selectFromView
                .transition(.move(edge: .bottom))
        case .destinationView:
            selectToView
                .transition(.move(edge: .bottom))
            
        }
    }
    
    private var selectToView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Destination address")
                .font(.system(size: 24, weight: .semibold))
            
            HStack {
                Text(input.to.isLoading ? "loading_address".localize : input.to.title)
                    .font(.system(size: 13))
                    .frame(height: 32)
                
                Spacer()
                
                Text(input.distance)
                    .font(.system(size: 13))
                    .foregroundStyle(Color.init(uiColor: .secondaryLabel))
            }
            
            SubmitButton {
                self.input.onClickReady()
            } label: {
                Text("done".localize)
            }.padding(.top, Padding.small)
            
        }
        .frame(maxWidth: .infinity)
    }
    
    private var selectFromView: some View {
        VStack {
            FromPointButton(text: input.from.title, isLoading: input.from.isLoading, onClickBody: input.from.onClickBody)
                .padding(.top, Padding.small / 2)
            
            ToPointButton(text: input.to.title, isLoading: input.to.isLoading, onClickMap: input.to.onClickMap, onClickBody: input.to.onClickBody)
            
            LazyHStack {
                ForEach(stations) { station in
                    gasStationItem(station).onTapGesture {
                        self.onClickOpen?(station)
                    }
                }
                
                if hasMoreButton {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: stationItemHeight)
                        .frame(width: UIApplication.shared.screenFrame.width * 0.8)
                        .foregroundStyle(Color.secondaryBackground)
                        .overlay {
                            Text("view_all".localize)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Color.init(uiColor: .secondaryLabel))
                        }
                        .onTapGesture {
                            onClickMoreButton?()
                        }
                }
            }
            .frame(maxHeight: 120)
            .padding(.horizontal, Padding.medium)
            .scrollable(axis: .horizontal)
            .padding(.horizontal, -Padding.medium)
            .scrollIndicators(.never)   
            .overlay {
                itemsOverlay
            }
        }
    }
    
    @ViewBuilder
    private var itemsOverlay: some View {
        if isSearching {
            VStack {
                VStack {
                    Image("icon_search_2")
                        .renderingMode(.template)
                        .foregroundStyle(Color.init(uiColor: .secondaryLabel))
                        .frame(width: 42, height: 42)
                    
                    Text("Searching stations")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.init(uiColor: .secondaryLabel))
                }.opacity(self.stations.isEmpty ? 1 : 0)
            }
        } else {
            VStack {
                Image("icon_search_failed")
                    .renderingMode(.template)
                    .foregroundStyle(Color.init(uiColor: .secondaryLabel))
                    .frame(width: 42, height: 42)
                
                Text("No stations found")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.init(uiColor: .secondaryLabel))
            }.opacity(self.stations.isEmpty ? 1 : 0)
        }
    }
    
    private func gasStationItem(_ station: StationItem) -> some View {
        GasStationItemView(station: station, stationItemHeight: stationItemHeight)
            .set { st in
                self.onClickNavigate?(st)
            }
    }
}

#Preview {
    HomeBottomSheetView(input: .init(from: .init(title: "A", isLoading: false, onClickBody: {
        
    }, onClickMap: {
        
    }), to: .init(title: "B", isLoading: false, onClickBody: {
        
    }, onClickMap: {
        
    }), onClickReady: {
        
    }, distance: "10"), stations: [
        .init(id: 0, name: "A", lat: 0, lng: 0, isDeleted: false, cityId: 1, customerId: 2, stateId: "NY")
    ], hasMoreButton: false, isSearching: true, onClickOpen:  { st in
        
    })
}

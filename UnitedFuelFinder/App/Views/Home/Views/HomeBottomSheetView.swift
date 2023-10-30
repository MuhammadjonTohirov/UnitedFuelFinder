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
    var onClickMoreButton: (() -> Void)? = nil
    private var stationItemHeight: CGFloat = 110
    
    init(input: HomeBottomSheetInput, stations: [StationItem], hasMoreButton: Bool, onClickMoreButton: (() -> Void)? = nil) {
        self.input = input
        self.stations = stations
        self.hasMoreButton = hasMoreButton
        self.onClickMoreButton = onClickMoreButton
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
                    gasStationItem(station)
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
            .padding(.top, 10)
            
        }
        
    }
    
    private func gasStationItem(_ station: StationItem) -> some View {
        GasStationItemView(station: station, stationItemHeight: stationItemHeight)
    }
}

#Preview {
    HomeBottomSheetView(input: .init(from: .init(title: "A", isLoading: false, onClickBody: {
        
    }, onClickMap: {
        
    }), to: .init(title: "B", isLoading: false, onClickBody: {
        
    }, onClickMap: {
        
    }), onClickReady: {
        
    }, distance: "10"), stations: [], hasMoreButton: true)
}

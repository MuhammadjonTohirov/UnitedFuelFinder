//
//  GasStationItemView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 30/10/23.
//

import Foundation
import SwiftUI

struct GasStationItemView: View {
    var station: StationItem
    var stationItemHeight: CGFloat = 120
    
    var onClickNavigate: ((StationItem) -> Void)?
    
    init(station: StationItem, stationItemHeight: CGFloat = 110) {
        self.station = station
        self.stationItemHeight = stationItemHeight
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image("image_ta")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 32)
                
                VStack(alignment: .leading) {
                    Text(station.name)
                    Text([station.distanceInfo(from: GLocationManager.shared.currentLocation?.coordinate), station.state?.id ?? ""].compactMap({$0.nilIfEmpty}).joined(separator: " • "))
                }
                .font(.system(size: 12))
                
                Spacer()
                
                Text(station.actualPriceInfo)
                    .foregroundStyle(Color.label)
                    .font(.system(size: 12))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 4)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Save \(station.discountInfo) per gallon ")
                    Text("Retail price \(station.retailPriceInfo)")
                }
                .font(.system(size: 12))
                
                Spacer()
                
                navigateButton
            }
        }
        .padding(Padding.medium)
        .frame(height: stationItemHeight)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color.secondaryBackground)
        }
        .frame(minWidth: UIApplication.shared.screenFrame.width * 0.8)
    }
    
    private var navigateButton: some View {
        Button(action: {
            self.onClickNavigate?(station)
        }, label: {
            Label(
                title: {
                    Text("navigate".localize)
                        .font(.system(size: 12, weight: .medium))
                },
                icon: {
                    Image(
                        "icon_navigation_point"
                    ).renderingMode(
                        .template
                    )
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(
                        Color.white
                    )
                }
            )
            .foregroundStyle(.white)
            .font(.system(size: 12))
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .background {
                RoundedRectangle(
                    cornerRadius: 6
                ).foregroundStyle(
                    Color.accentColor
                )
            }
        })
    }
    
    func set(navigate: @escaping (StationItem) -> Void) -> Self {
        var v = self
        v.onClickNavigate = navigate
        
        return v
    }
}

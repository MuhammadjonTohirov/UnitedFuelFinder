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
                    Text("\(station.distanceInfo(from: GLocationManager.shared.currentLocation?.coordinate)) • \(station.state?.id ?? "")")
                }
                .font(.system(size: 12))
                
                Spacer()
                
                Text(station.actualPriceInfo)
                    .foregroundStyle(.white)
                    .font(.system(size: 12))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 4)
                    .background {
                        RoundedRectangle(
                            cornerRadius: 4
                        ).foregroundStyle(
                            Color.accentColor
                        )
                    }
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Save \(station.discountInfo) per gallon ")
                    Text("Retail price \(station.retailPriceInfo)")
                }
                .font(.system(size: 12))
                
                Spacer()
                
                Label(
                    title: {
                        Text("Get Direction")
                    },
                    icon: {
                        Image(
                            "icon_navigator"
                        ).renderingMode(
                            .template
                        ).foregroundStyle(
                            Color.white
                        )
                    }
                )
                .foregroundStyle(.white)
                .font(.system(size: 12))
                .padding(.vertical, 2)
                .padding(.horizontal, 4)
                .background {
                    RoundedRectangle(
                        cornerRadius: 6
                    ).foregroundStyle(
                        Color.accentColor
                    )
                }
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
}

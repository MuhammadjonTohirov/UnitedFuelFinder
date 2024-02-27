//
//  GasStationItemView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 30/10/23.
//

import Foundation
import SwiftUI
import Kingfisher

struct GasStationItemView: View {
    var station: StationItem
    var stationItemHeight: CGFloat = 120
    
    var onClickNavigate: ((StationItem) -> Void)?
    
    init(station: StationItem, stationItemHeight: CGFloat = 120) {
        self.station = station
        self.stationItemHeight = stationItemHeight
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                logo
                    .padding(.trailing, 8)
                
                info
                
                Spacer()
                
                Text(station.actualPriceInfo)
                    .foregroundStyle(Color.label)
                    .font(.system(size: 12))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 4)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("save.n.galon".localize(arguments: station.discountInfo))
                        .font(.system(size: 12))

                    Text("retail.price.n".localize(arguments: station.retailPriceInfo))
                        .font(.system(size: 12))
                }
                .opacity(0.85)
                
                Spacer()
                
                navigateButton
                    .opacity(onClickNavigate == nil ? 0 : 1)
            }
        }
        .padding(Padding.medium)
        .frame(height: stationItemHeight.sh())
        .frame(minWidth: 325.f.sw())
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color.appSecondaryBackground)
        }
    }
    
    private var info: some View {
        VStack(alignment: .leading) {
            Text(station.name)
            Text([
                station.distanceInfo(from: GLocationManager.shared.currentLocation?.coordinate),
                station.address ?? ""
            ].compactMap({$0.nilIfEmpty}).joined(separator: " • "))
            .foregroundStyle(Color.init(uiColor: .secondaryLabel))
        }
        .font(.system(size: 12))
    }
    
    private var logo: some View {
        KFImage(.init(string: station.customer?.iconUrl ?? ""))
            .placeholder {
                Image("image_placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 32)
            }
            .setProcessor(
                ResizingImageProcessor(referenceSize: CGSize(width: 32, height: 32))
            )
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .frame(height: 32)
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.appSecondaryBackground, lineWidth: 1)
            )
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

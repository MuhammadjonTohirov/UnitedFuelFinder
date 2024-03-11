//
//  GasStationItemView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 30/10/23.
//

import Foundation
import SwiftUI
import Kingfisher
import CoreLocation

struct GasStationItemView: View {
    var station: StationItem
    var fromPoint: CLLocationCoordinate2D? = nil
    
    var onClickNavigate: ((StationItem) -> Void)?
    
    // deprecated
    @available(*, deprecated, message: "Use init(station: StationItem, fromPoint: CLLocationCoordinate2D?) instead")
    init(station: StationItem, stationItemHeight: CGFloat, fromPoint: CLLocationCoordinate2D? = nil) {
        self.station = station
        self.fromPoint = fromPoint
    }
    
    init(station: StationItem, fromPoint: CLLocationCoordinate2D? = nil) {
        self.station = station
        self.fromPoint = fromPoint
    }
    
    var body: some View {
        VStack(spacing: Padding.small) {
            HStack {
                logo
                    .padding(.trailing, 8)
                
                info
                
                Spacer()
                
                Text(station.actualPriceInfo)
                    .foregroundStyle(Color.label)
                    .font(.system(size: 12, weight: .semibold))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 4)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    discountInfoView
                    retailPriceView
                }
                .opacity(0.85)
                
                Spacer()
                
                navigateButton
                    .opacity(onClickNavigate == nil ? 0 : 1)
            }
            
            RoundedRectangle(cornerRadius: 4)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color.init(uiColor: .separator))
                .frame(height: 24.f.sh())
                .overlay {
                    HStack {
                        Text(station.fullAddress.nilIfEmpty ?? "no.address".localize)
                            .font(.system(size: 11))
                            .foregroundStyle(Color.label)
                        Spacer()
                    }
                    .padding(.horizontal, Padding.small)
                }
            
        }
        .padding(.horizontal, Padding.medium)
        .padding(.vertical, Padding.medium - 4)
        .frame(minWidth: 325.f.sw())
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color.appSecondaryBackground)
        }
    }
    
    private var discountInfoView: some View {
        Text(
            AttributedString(
                "save".localize,
                attributes: .init([
                    NSAttributedString.Key.foregroundColor: UIColor.label,
                ])
            ) + " " +
            AttributedString(
                station.discountInfo,
                attributes: .init([
                    NSAttributedString.Key.foregroundColor: UIColor.label,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                ])
            ) +
            AttributedString(
                " " + "per.gallon".localize,
                attributes: .init([
                    NSAttributedString.Key.foregroundColor: UIColor.label,
                ])
            )
        )
        .font(.system(size: 12))
    }
    
    private var retailPriceView: some View {
        Text(
            AttributedString(
                "retail_price".localize,
                attributes: .init([
                    NSAttributedString.Key.foregroundColor: UIColor.label,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                ])
            )
            + " " +
            AttributedString(
                station.retailPriceInfo,
                attributes: .init([
                    NSAttributedString.Key.foregroundColor: UIColor.label,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                ])
            )
        )
        .font(.system(size: 12))
    }
    
    private var info: some View {
        VStack(alignment: .leading) {
            Text(station.name)
            Text(station.distanceFromCurrentLocationInfo)
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
        })
    }
    
    func set(navigate: @escaping (StationItem) -> Void) -> Self {
        var v = self
        v.onClickNavigate = navigate
        
        return v
    }
}

#Preview {
    GasStationItemView(station: .init(id: 0, name: "Name", lat: 0, lng: 0, isDeleted: false, cityId: 0, customerId: 0, stateId: "Fergana", priceUpdated: "100", note: "Note"), fromPoint: nil)
}

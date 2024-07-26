//
//  StationTipInfoView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/11/23.
//

import Foundation
import SwiftUI

struct StationTipView: View {
    
    let station: StationItem
    let onClickShow: (StationItem) -> Void
    let onClickNavigate: (StationItem) -> Void
    
    var userInfo: UserInfo? {
        UserSettings.shared.userInfo
    }
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(station.displayName ?? station.name)
                .font(.lato(size: 16, weight: .semibold))
                .horizontal(alignment: .leading)
            
            Divider()
            
            HStack {
                Text("price_update".localize)
                    .font(.lato(size: 13, weight: .regular))
                Spacer()
                Text(station.priceUpdateInfo)
            }
            
            HStack {
                Text("discounted_price".localize)
                    .font(.lato(size: 13, weight: .regular))
                Spacer()
                Text(station.actualPriceInfo)
            }
            .font(.lato(size: 13, weight: .semibold))
            .set(isVisible: userInfo?.showDiscountedPrices ?? true)

            HStack {
                Text("discount".localize)
                Spacer()
                Text(station.discountInfo)
            }
            .font(.lato(size: 13, weight: .regular))
            .set(isVisible: userInfo?.showDiscountPrices ?? true)
            
            HStack {
                Text("retail_price".localize)
                Spacer()
                Text(station.retailPriceInfo)
            }
            .font(.lato(size: 13, weight: .regular))

            Divider()
            
            HStack {
                Text("address".localize)
                Spacer()
                Text(station.fullAddress)
            }
            
            HStack {
                Icon(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.accent)
                
                Text("price.change.warning".localize)
                    .font(.lato(size: 12, weight: .regular))
                    .foregroundStyle(Color.secondary)
            }
            .frame(height: 40.f.sh())
            
            actions
        }
        .font(.lato(size: 13, weight: .regular))
        .padding()
    }
    
    private var actions: some View {
        HStack {
            RegularButton(action: {
                dismiss.callAsFunction()
            }, label: {
                Text("close".localize.capitalized)
                    .foregroundStyle(Color.label)
                    .font(.lato(size: 12, weight: .medium))
            }, height: 40)
            
            Spacer()
            
            SubmitButton(action: {
                dismiss.callAsFunction()
                onClickShow(station)
            }, label: {
                Text("view_larger".localize)
                    .font(.lato(size: 12, weight: .medium))
                    .foregroundStyle(Color.white)
            }, backgroundColor: Color.init(uiColor: .systemGreen), height: 40)
            
            Spacer()
            
            SubmitButton(action: {
                dismiss.callAsFunction()
                onClickNavigate(station)
            }, label: {
                Text("navigate".localize)
                    .font(.lato(size: 12, weight: .medium))
            }, height: 40)
        }
        .padding(.top, Padding.small)
    }
}

#Preview {
    StationTipView(
        station: StationItem.init(
            id: 0,
            name: "LOVES 347",
            lat: 44.19283,
            lng: 79.91823,
            isDeleted: false,
            cityId: 0,
            customerId: 0,
            stateId: "NY",
            priceUpdated: "12.10.2024",
            note: "No note"
        ),
        onClickShow: { station in
            
        }) { station in
            
        }
}

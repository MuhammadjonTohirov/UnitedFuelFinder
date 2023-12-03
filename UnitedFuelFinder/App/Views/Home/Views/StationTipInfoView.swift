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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(station.displayName)
                .font(.system(size: 16, weight: .semibold))
            
            Divider()
            
            Text("prices".localize.capitalized)
                .font(.system(size: 14, weight: .medium))
            
            HStack {
                Text("discount".localize)
                Spacer()
                Text(station.discountInfo)
            }
            
            HStack {
                Text("retail_price".localize)
                Spacer()
                Text(station.retailPriceInfo)
            }
            
            Divider()
            
            HStack {
                Text("address".localize)
                Spacer()
                Text(station.address ?? "")
            }
            
            
            HStack {
                RegularButton(action: {
                    dismiss.callAsFunction()
                }, label: {
                    Text("close".localize.capitalized)
                        .foregroundStyle(Color.label)
                        .font(.system(size: 12))
                }, height: 40)
                .frame(width: 100)
                
                Spacer()
                
                SubmitButton(action: {
                    dismiss.callAsFunction()
                    onClickShow(station)
                }, label: {
                    Text("view_larger".localize)
                        .font(.system(size: 12))
                }, height: 40)
            }
            .padding(.top, Padding.small)
        }
        .font(.system(size: 13, weight: .regular))
        .padding()
        .frame(height: 190)
        
    }
}


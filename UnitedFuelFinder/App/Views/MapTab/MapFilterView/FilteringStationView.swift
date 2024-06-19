//
//  FilteringStationView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 22/05/24.
//

import Foundation
import SwiftUI

struct FilteringStationView: View {
    var logo: String
    var title: String
    var isSelected: Bool
    
    @State
    private var bigRect: CGRect = .zero
    var body: some View {
        Rectangle()
            .foregroundStyle(.clear)
            .overlay {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundStyle(
                            isSelected ? .appCardBackground : .clear
                        )
                        .border(.appDarkGray2, width: 1, cornerRadius: 6)
                        .padding(.bottom, 8)
                        .readRect(rect: $bigRect)
                        .overlay(content: {content})
                    
                    RoundedRectangle(cornerRadius: 1)
                        .frame(width: 13, height: 13)
                        .foregroundStyle(isSelected ? .appCardBackground : .clear)
                        .border(
                            .appDarkGray2, width: 1.3, cornerRadius: 1
                        )
                        .overlay {
                            Image("icon_check")
                                .resizable()
                                .frame(width: 10, height: 10, alignment: .center)
                                .opacity(isSelected ? 1 : 0)
                        }
                        .position(.init(x: bigRect.width / 2, y: bigRect.height - 8))
                }
            }
    }
    
    private var content: some View {
        VStack {
            AsyncImage(
                url: .init(string: logo)
            ) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
                    .frame(height: 44)
            }
            .frame(width: 38, height: 44)
            Text(title)
                .foregroundStyle(isSelected ? Color.accent : .label)
                .font(.system(size: 12, weight: .medium))
        }
    }
}

#Preview {
    FilteringStationView(logo: "", title: "TA/Petro", isSelected: false)
        
}

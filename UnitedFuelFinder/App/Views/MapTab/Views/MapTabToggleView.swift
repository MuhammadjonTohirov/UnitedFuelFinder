//
//  MapTabToggleView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 10/02/24.
//

import Foundation
import SwiftUI

struct MapTabToggleView: View {
    @Binding var selectedIndex: HomeBodyState
    var body: some View {
        HStack(spacing: 0) {
            toggleItem("map".localize, selectedIndex == .map)
                .onTapGesture {
                    select(index: .map)
                }
            
            toggleItem("list".localize, selectedIndex == .list)
                .onTapGesture {
                    select(index: .list)
                }
        }
        .padding(2)
        .background {
            Capsule()
                .foregroundStyle(Color.tertiaryBackground)
        }
        .background {
            Capsule()
                .stroke(lineWidth: 1)
                .foregroundStyle(Color.secondary)
        }
    }
    
    private func toggleItem(_ text: String, _ selected: Bool) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .medium))
            .frame(width: 74.f.sw(), height: 40.f.sh())
            .foregroundStyle(selected ? .white : .label)
            .background {
                Capsule()
                    .foregroundStyle(selected ? .accent : .tertiaryBackground)
            }
    }
    
    private func select(index: HomeBodyState) {
        withAnimation {
            self.selectedIndex = index
        }
    }
}

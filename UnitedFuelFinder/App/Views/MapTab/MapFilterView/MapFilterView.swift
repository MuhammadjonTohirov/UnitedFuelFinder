//
//  MapFilterView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 10/02/24.
//

import Foundation
import SwiftUI

struct MapFilterView: View {
    @State private var fromPriceRange: String = ""
    @State private var toPriceRange: String = ""
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                sortedByRow
                Divider()
                priceRange
                radiusView
                stationsView
            }
            .scrollable()
            
            VStack {
                Spacer()
                
                SubmitButton {
                    
                } label: {
                    Text("apply".localize.capitalized)
                }
                .padding(.horizontal, Padding.default)
                .padding(.bottom, Padding.default)
            }
        }
    }
    
    private var sortedByRow: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sorted by")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.label)
            
            HStack {
                selectionButton(title: "Distance", isSelected: true)
                selectionButton(title: "Price", isSelected: false)
            }
        }
        .padding(.horizontal, Padding.default)
    }
    
    private var priceRange: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sorted by")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.label)
            
            HStack {
                YRoundedTextField {
                    YTextField(text: $fromPriceRange, placeholder: "from".localize)
                        .keyboardType(.numberPad)
                }
                
                YRoundedTextField {
                    YTextField(text: $toPriceRange, placeholder: "to".localize)
                        .keyboardType(.numberPad)
                }
            }
        }
        .padding(.horizontal, Padding.default)
    }
    
    private var radiusView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Radius (in miles)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.label)
            
            YRoundedTextField {
                YTextField(text: $fromPriceRange, placeholder: "radius".localize)
                    .keyboardType(.numberPad)
            }
        }
        .padding(.horizontal, Padding.default)
    }
    
    private var stationsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Stations")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.label)
            
            HStack {
                selectionButton(title: "Company 1", isSelected: true)
                selectionButton(title: "Company 2", isSelected: true)
                selectionButton(title: "Company 3", isSelected: false)
            }
        }
        .padding(.horizontal, Padding.default)

    }
    
    func selectionButton(title: String, isSelected: Bool) -> some View {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .frame(height: 22)
            .padding(.horizontal, 16)
            .padding(.vertical, 5)
            .foregroundStyle(isSelected ? .white : .black)
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .frame(height: 32)
                    .foregroundStyle(isSelected ? Color.accent : .clear)
            }
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(style: StrokeStyle(lineWidth: 1))
                    .foregroundStyle(Color.accent)
                    .opacity(isSelected ? 0 : 1)
            }
    }
}

#Preview {
    MapFilterView()
}

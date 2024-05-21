//
//  TotalCostView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/05/24.
//

import Foundation
import SwiftUI

struct TotalCostView: View {
    var value: String
    var body: some View {
        RoundedRectangle(cornerRadius: 10.f.sw())
            .frame(width: 62, height: 44)
            .overlay {
                VStack(spacing: 0) {
                    Text("toll.cost".localize)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color.white)
                        .frame(height: 22)
                        
                    Rectangle()
                        .foregroundStyle(Color.white)
                        .frame(height: 22)
                        .overlay {
                            Text(value)
                        }
                }
                .font(.system(size: 12, weight: .medium))
            }
            // setup border 1 with radius 10
            .border(.secondary, width: 1, cornerRadius: 10.f.sw())
    }
}

#Preview {
    TotalCostView(value: "$150")
}

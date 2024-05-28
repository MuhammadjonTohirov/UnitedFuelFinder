//
//  StationDetailsWarning.swift
//  UnitedFuelFinder
//
//  Created by applebro on 22/05/24.
//

import Foundation
import SwiftUI

struct StationDetailsWarning: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .padding(.horizontal, Padding.default)
            .frame(height: 48)
            .foregroundStyle(Color.accentColor.opacity(0.08))
            .overlay {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .frame(width: 36.f.sw(), height: 32.f.sw(), alignment: .center)
                    Text("price.change.warning".localize)
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundStyle(.accent)
            }
    }
}

#Preview {
    StationDetailsWarning()
}

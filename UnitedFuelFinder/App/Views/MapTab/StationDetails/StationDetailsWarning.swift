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
        HStack {
            Icon(systemName: "exclamationmark.triangle.fill")
                .frame(width: 32.f.sw(), height: 28.f.sw(), alignment: .center)
            Text("price.change.warning".localize)
                .multilineTextAlignment(.leading)
                .font(.lato(size: 12, weight: .semibold))
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(.red)
        .padding(.horizontal, 4)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 48)
                .foregroundStyle(Color.red.opacity(0.08))
        }
    }
}

#Preview {
    StationDetailsWarning()
}

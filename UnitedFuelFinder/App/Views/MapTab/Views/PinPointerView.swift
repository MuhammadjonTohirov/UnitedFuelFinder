//
//  PinPointerView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/10/23.
//

import Foundation
import SwiftUI

enum PinPointerType {
    case pinA
    case pinB
    
    var imageName: String {
        switch self {
        case .pinA:
            return "icon_pin_a"
        case .pinB:
            return "icon_pin_b"
        }
    }
}

struct PinPointerView: View {
    var isActive: Bool = true
    var type: PinPointerType

    var body: some View {
        ZStack {
            Image(type.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 50)
                .shadow(color: Color.black.opacity(0.15), radius: 2)
                .offset(.init(width: 0, height: isActive ? -58 : -44))
            Circle()
                .foregroundStyle(Color.clear)
                .frame(width: 14, height: 14)
                .overlay {
                    Image(isActive ? "icon_dot_large" : "icon_dot_small")
                        .opacity(0.8)
                }
                .padding(.bottom, 32)
        }
        .allowsHitTesting(false)
    }
}

#Preview {
    return PinPointerView(type: .pinA)
}

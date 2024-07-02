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
    case custom(label: Character)
    
    var imageName: String {
        switch self {
        case .pinA:
            return "icon_pin_a"
        case .pinB:
            return "icon_pin_b"
        case .custom:
            return "icon_pin_pointer"
        }
    }
}

struct PinPointerView: View {
    var isActive: Bool = true
    var label: Character

    var body: some View {
        ZStack {
            Image("icon_pin_pointer")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 50)
                .overlay {
                    Text(label.description.uppercased())
                        .font(.bold(size: 10))
                        .padding(.bottom, 20)
                        .foregroundStyle(Color.white)
                }
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
    return PinPointerView(label: "b".first!)
}

//
//  CoverNavigationBarModifier.swift
//  UnitedFuelFinder
//
//  Created by applebro on 16/02/24.
//

import Foundation
import SwiftUI

struct CoverNavigationBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            content
            
            GeometryReader(content: { geometry in
                VStack(spacing: 0) {
                    Rectangle()
                        .frame(height: geometry.safeAreaInsets.top)
                        .foregroundStyle(Color.init(uiColor: .systemBackground))
                        .ignoresSafeArea()

                    
                    Spacer()
                }
            })
        }
    }
}

extension View {
    func coverNavigationBar() -> some View {
        self.modifier(CoverNavigationBarModifier())
    }
}

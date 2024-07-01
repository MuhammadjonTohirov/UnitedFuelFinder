//
//  CoveredLoadingView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 12/11/23.
//

import Foundation
import SwiftUI
import SwiftfulLoadingIndicators

public struct CoveredLoadingView: View {
    @Binding public var isLoading: Bool
    public var message: String
    
    init(isLoading: Binding<Bool>, message: String) {
        self._isLoading = isLoading
        self.message = message
    }
    
    public var body: some View {
        Rectangle()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundStyle(Color.background.opacity(0.6))
            .ignoresSafeArea()
            .overlay {
                VStack {
//                    LoadingIndicator(animation: .circleTrim, color: .label, size: .medium, speed: .normal)
                    ActivityIndicatorView()
                    Text(message)
                        .background {
                            Capsule()
                                .foregroundStyle(Color.background)
                                .blur(radius: 10)
                        }
                }
            }.opacity(isLoading ? 1 : 0)
    }
}

struct CoveredLoadingModifier: ViewModifier {
    @Binding var isLoading: Bool
    var message: String
    
    func body(content: Content) -> some View {
        ZStack {
            content
            CoveredLoadingView(isLoading: $isLoading, message: message)
        }
    }
}

extension View {
    public func coveredLoading(isLoading: Binding<Bool>, message: String = "") -> some View {
        self.modifier(CoveredLoadingModifier(isLoading: isLoading, message: message))
    }
}
